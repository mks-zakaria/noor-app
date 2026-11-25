#!/usr/bin/env python3
"""Upload screenshots to the editable App Store version, one locale at a time.

`push.py` writes text; screenshots are a different animal — a three-step reserve /
PUT / commit dance per image — so they live here. Transport, auth and version
discovery are imported rather than duplicated.

    python3 push_screenshots.py --locale fr-FR                  # dry run
    python3 push_screenshots.py --locale fr-FR --apply
    python3 push_screenshots.py --locale fr-FR --dir ../marketing-fr-new --apply

Layout expected under --dir: one folder per display size, images sorted by name.

    marketing-fr-new/6.9-inch/1-prayer.png
    marketing-fr-new/6.5-inch/1-prayer.png

Re-running is safe: an image whose file name is already in the set is left alone,
so a partial run can simply be repeated.
"""
import argparse
import hashlib
import pathlib
import struct
import sys
import urllib.request

import push
from push import ApiError, call, paged

# Folder name → Apple's display-type enum. The enum names lag the marketing
# names by a generation: APP_IPHONE_67 *is* the 6.9" slot, and APP_IPHONE_69
# does not exist. Getting this wrong reserves the asset against the wrong slot
# and Apple rejects the dimensions rather than the name, which reads as a bad
# image.
DISPLAY_TYPES = {
    "6.9-inch": "APP_IPHONE_67",
    "6.5-inch": "APP_IPHONE_65",
    "13-inch": "APP_IPAD_PRO_3GEN_129",
}

# Portrait pixel sizes Apple accepts per slot. Checked before upload because the
# server-side failure arrives after the bytes have already gone up.
VALID_SIZES = {
    "APP_IPHONE_67": {(1290, 2796), (1320, 2868)},
    "APP_IPHONE_65": {(1242, 2688), (1284, 2778)},
    "APP_IPAD_PRO_3GEN_129": {(2048, 2732), (2064, 2752)},
}


def png_size(path: pathlib.Path) -> tuple[int, int]:
    """Width and height straight out of the PNG IHDR — no image library needed."""
    header = path.read_bytes()[:24]
    if header[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit(f"{path} is not a PNG")
    return struct.unpack(">II", header[16:24])


def version_localization(version_id: str, locale: str) -> str:
    for loc in paged(f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations"):
        if loc["attributes"]["locale"] == locale:
            return loc["id"]
    raise SystemExit(
        f"no {locale} localization on this version — run push.py first, it creates them"
    )


def screenshot_set(localization_id: str, display_type: str, apply: bool) -> str:
    """Find the set for this display size, creating it if the locale has none."""
    for s in paged(f"/v1/appStoreVersionLocalizations/{localization_id}/appScreenshotSets"):
        if s["attributes"]["screenshotDisplayType"] == display_type:
            return s["id"]
    if not apply:
        return ""
    created = call("POST", "/v1/appScreenshotSets", {
        "data": {
            "type": "appScreenshotSets",
            "attributes": {"screenshotDisplayType": display_type},
            "relationships": {
                "appStoreVersionLocalization": {
                    "data": {"type": "appStoreVersionLocalizations", "id": localization_id}
                }
            },
        }
    })
    return created["data"]["id"]


def upload(set_id: str, path: pathlib.Path) -> str:
    """Reserve, PUT the bytes, then commit with a checksum. Returns the asset id.

    Apple hands back one or more `uploadOperations`, each a presigned URL for a
    byte range — so the file is sliced by their offsets rather than sent whole,
    and those requests must NOT carry our Authorization header.
    """
    blob = path.read_bytes()
    reserved = call("POST", "/v1/appScreenshots", {
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": path.name, "fileSize": len(blob)},
            "relationships": {
                "appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}
            },
        }
    })
    asset_id = reserved["data"]["id"]

    for op in reserved["data"]["attributes"]["uploadOperations"]:
        chunk = blob[op["offset"]:op["offset"] + op["length"]]
        request = urllib.request.Request(op["url"], data=chunk, method=op["method"])
        for header in op.get("requestHeaders", []):
            request.add_header(header["name"], header["value"])
        with urllib.request.urlopen(request) as response:
            response.read()

    call("PATCH", f"/v1/appScreenshots/{asset_id}", {
        "data": {
            "type": "appScreenshots",
            "id": asset_id,
            "attributes": {"uploaded": True, "sourceFileChecksum": hashlib.md5(blob).hexdigest()},
        }
    })
    return asset_id


def reorder(set_id: str, asset_ids: list[str]) -> None:
    """Pin display order to file-name order; upload order alone is not a promise."""
    call("PATCH", f"/v1/appScreenshotSets/{set_id}/relationships/appScreenshots", {
        "data": [{"type": "appScreenshots", "id": i} for i in asset_ids]
    })


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--locale", required=True, help="e.g. fr-FR")
    parser.add_argument("--dir", default="../marketing-fr-new",
                        help="folder holding the per-size subfolders")
    parser.add_argument("--apply", action="store_true", help="actually upload")
    args = parser.parse_args()

    root = pathlib.Path(__file__).parent / args.dir
    if not root.is_dir():
        raise SystemExit(f"no such folder: {root}")

    sizes = sorted(d for d in root.iterdir() if d.is_dir() and d.name in DISPLAY_TYPES)
    if not sizes:
        raise SystemExit(f"no recognised size folders in {root} "
                         f"(expected {', '.join(DISPLAY_TYPES)})")

    if not push.KEY_PATH.exists():
        raise SystemExit(f"missing API key at {push.KEY_PATH}")
    push.TOKEN = push.make_token()

    version_id, version_string, _ = push.editable_version(None, args.apply)
    localization_id = version_localization(version_id, args.locale)

    mode = "APPLYING" if args.apply else "DRY RUN (nothing is uploaded — pass --apply)"
    print(f"{mode} · {args.locale} · version {version_string}\n")

    failures = 0
    for folder in sizes:
        display_type = DISPLAY_TYPES[folder.name]
        images = sorted(folder.glob("*.png"))
        if not images:
            continue

        for image in images:
            size = png_size(image)
            if size not in VALID_SIZES[display_type]:
                allowed = " or ".join(f"{w}x{h}" for w, h in sorted(VALID_SIZES[display_type]))
                print(f"  {folder.name:10} {image.name:16} REJECTED "
                      f"{size[0]}x{size[1]}, {display_type} takes {allowed}")
                failures += 1
        if failures:
            continue

        set_id = screenshot_set(localization_id, display_type, args.apply)
        existing = {s["attributes"]["fileName"]: s["id"]
                    for s in (paged(f"/v1/appScreenshotSets/{set_id}/appScreenshots")
                              if set_id else [])}

        ordered = []
        for image in images:
            if image.name in existing:
                ordered.append(existing[image.name])
                print(f"  {folder.name:10} {image.name:16} already there")
                continue
            if not args.apply:
                print(f"  {folder.name:10} {image.name:16} would upload "
                      f"({display_type}, {png_size(image)[0]}x{png_size(image)[1]})")
                continue
            try:
                ordered.append(upload(set_id, image))
                print(f"  {folder.name:10} {image.name:16} uploaded")
            except (ApiError, OSError) as exc:
                print(f"  {folder.name:10} {image.name:16} FAILED {exc}")
                failures += 1

        if args.apply and len(ordered) == len(images):
            reorder(set_id, ordered)

    print()
    if failures:
        print(f"{failures} image(s) failed — fix and re-run; uploaded ones are skipped")
        return 1
    if not args.apply:
        print("Dry run only. Re-run with --apply to upload.")
    elif args.locale == "en-US":
        print("Done. en-US is the fallback every unlocalized storefront renders.")
    else:
        print(f"Done. {args.locale} now has its own screenshots instead of "
              f"falling back to en-US.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
