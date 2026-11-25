#!/usr/bin/env python3
"""iOS 27+ creative assets: product page header + search results image.

Images come from store/creative/{header,search}-{en,ar,fr}.png, rendered by
store/creative/make_creative.swift. Three stages, all idempotent:

  1. upload  — each image into the app's asset library (category CREATIVE_ASSETS):
               POST /v1/appAssetLibraryImages → PUT uploadOperations →
               PATCH {uploaded: true} (no sourceFileChecksum, it 409s).
  2. submit  — a live (READY_FOR_SALE) version only takes APPROVED images, so new
               ones go to App Review on their own, no build needed:
               POST /v1/reviewSubmissions → one reviewSubmissionItem per image
               (relationship `appAssetLibraryImage`) → PATCH {submitted: true}.
               Only with --submit.
  3. place   — POST /v1/appAssetLibraryPlacements {placementType, image,
               appStoreVersionLocalization}. Done for every image that is APPROVED,
               or for any image when the version is still editable.

    python3 push_creative.py                    # dry run, prints image states
    python3 push_creative.py --apply            # upload + place what can be placed
    python3 push_creative.py --apply --submit   # ...and send pending images to review
"""
import argparse
import pathlib
import urllib.request

import push
from push import APP_ID, ApiError, call, paged

CREATIVE = pathlib.Path(__file__).resolve().parent.parent / "creative"
PLACEMENTS = {"PRODUCT_PAGE_HEADER_ASSET": "header", "APP_STORE_SEARCH_RESULTS_ASSET": "search"}
# Store locale → rendered copy. Locales without their own copy fall back to the
# primary (en-US) listing on the store.
LOCALES = {"en-US": "en", "ar-SA": "ar", "fr-FR": "fr", "fr-CA": "fr"}
EDITABLE = {"PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED", "WAITING_FOR_REVIEW"}


def image_name(stem, code):
    return f"noor-{stem}-{code}.png"


def upload(name, path):
    data = path.read_bytes()
    j = call("POST", "/v1/appAssetLibraryImages", {"data": {"type": "appAssetLibraryImages",
        "attributes": {"fileName": name, "fileSize": len(data), "category": "CREATIVE_ASSETS"},
        "relationships": {"assetLibrary": {"data": {"type": "appAssetLibraries", "id": APP_ID}}}}})
    image_id = j["data"]["id"]
    for op in j["data"]["attributes"].get("uploadOperations") or []:
        req = urllib.request.Request(op["url"], data=data[op["offset"]:op["offset"] + op["length"]], method=op["method"],
                                     headers={h["name"]: h["value"] for h in op["requestHeaders"]})
        urllib.request.urlopen(req).read()
    call("PATCH", f"/v1/appAssetLibraryImages/{image_id}", {"data": {"type": "appAssetLibraryImages",
        "id": image_id, "attributes": {"uploaded": True}}})
    return image_id


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--submit", action="store_true", help="send images that are not approved yet to App Review")
    ap.add_argument("--version", help="versionString; default = newest iOS version")
    args = ap.parse_args()
    push.TOKEN = push.make_token()

    versions = [v for v in paged(f"/v1/apps/{APP_ID}/appStoreVersions") if v["attributes"]["platform"] == "IOS"]
    version = next(v for v in versions if not args.version or v["attributes"]["versionString"] == args.version)
    vstate = version["attributes"]["appStoreState"]
    editable = vstate in EDITABLE
    print("version", version["attributes"]["versionString"], vstate)

    # 1. upload
    library = {i["attributes"]["fileName"]: i for i in paged(f"/v1/appAssetLibraries/{APP_ID}/images")}
    for stem in PLACEMENTS.values():
        for code in sorted(set(LOCALES.values())):
            name = image_name(stem, code)
            if name in library:
                continue
            if not args.apply:
                print(f"would upload {name}")
                continue
            upload(name, CREATIVE / f"{stem}-{code}.png")
            print(f"uploaded {name}")
    library = {i["attributes"]["fileName"]: i for i in paged(f"/v1/appAssetLibraries/{APP_ID}/images")}
    ours = {n: i for n, i in library.items() if n.startswith("noor-")}
    for n, i in sorted(ours.items()):
        print(f"  {n:24} {i['attributes']['state']}")

    # 2. submit
    pending = [i for i in ours.values() if i["attributes"]["state"] == "PREPARE_FOR_SUBMISSION"]
    if args.submit and args.apply and pending and not editable:
        sub = call("POST", "/v1/reviewSubmissions", {"data": {"type": "reviewSubmissions", "attributes": {"platform": "IOS"},
            "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}}}})["data"]["id"]
        for i in pending:
            call("POST", "/v1/reviewSubmissionItems", {"data": {"type": "reviewSubmissionItems", "relationships": {
                "reviewSubmission": {"data": {"type": "reviewSubmissions", "id": sub}},
                "appAssetLibraryImage": {"data": {"type": "appAssetLibraryImages", "id": i["id"]}}}}})
        call("PATCH", f"/v1/reviewSubmissions/{sub}", {"data": {"type": "reviewSubmissions", "id": sub, "attributes": {"submitted": True}}})
        print(f"submitted {len(pending)} images for review (submission {sub})")
    elif pending and not editable:
        print(f"{len(pending)} images await review — re-run with --apply --submit")

    # 3. place
    locs = {l["attributes"]["locale"]: l["id"] for l in paged(f"/v1/appStoreVersions/{version['id']}/appStoreVersionLocalizations")}
    for locale, code in LOCALES.items():
        existing = {p["attributes"]["placementType"] for p in paged(f"/v1/appStoreVersionLocalizations/{locs[locale]}/placements")}
        for ptype, stem in PLACEMENTS.items():
            img = ours.get(image_name(stem, code))
            if ptype in existing:
                print(f"skip   {locale:6} {ptype} (already placed)")
            elif not img or not (editable or img["attributes"]["state"] == "APPROVED"):
                print(f"wait   {locale:6} {ptype} (image not approved yet)")
            elif not args.apply:
                print(f"would  {locale:6} {ptype} <- {image_name(stem, code)}")
            else:
                call("POST", "/v1/appAssetLibraryPlacements", {"data": {"type": "appAssetLibraryPlacements",
                    "attributes": {"placementType": ptype},
                    "relationships": {"image": {"data": {"type": "appAssetLibraryImages", "id": img["id"]}},
                                      "appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": locs[locale]}}}}})
                print(f"placed {locale:6} {ptype} <- {image_name(stem, code)}")


if __name__ == "__main__":
    try:
        main()
    except ApiError as e:
        raise SystemExit(f"FAIL {e}")
