#!/usr/bin/env python3
"""Push every locale in this folder to App Store Connect.

Name and subtitle live on the *app info* record (they apply to the app itself);
description, keywords, promotional text and release notes live on the *version*
record. This script writes both, creating a localization where one is missing and
patching it where one already exists, so it is safe to re-run.

    python3 push.py                 # dry run — shows exactly what would change
    python3 push.py --apply         # write it
    python3 push.py --apply --only ar-SA,tr,id
    python3 push.py --apply --create-version 1.1.0

Needs the App Store Connect key at ~/.appstoreconnect/private_keys/, and network
access — run it from a normal terminal, not from a sandboxed tool.
"""
import argparse
import base64
import json
import pathlib
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec, utils as asy_utils

from validate import load_all  # single source of truth for the locale content

APP_ID = "6790552873"
KEY_ID = "FRT72JC9WV"
ISSUER_ID = "c8bca885-6780-4d7c-9b6a-494f61367030"
KEY_PATH = pathlib.Path.home() / ".appstoreconnect/private_keys" / f"AuthKey_{KEY_ID}.p8"

SUPPORT_URL = "https://mks-zakaria.github.io/noor/support.html"
MARKETING_URL = "https://mks-zakaria.github.io/noor/"
PRIVACY_URL = "https://mks-zakaria.github.io/noor/privacy.html"

BASE = "https://api.appstoreconnect.apple.com"

# Fields that belong to each record type. Anything else in a locale file is ignored
# by the pusher rather than sent to an endpoint that will reject it.
APP_INFO_FIELDS = ["name", "subtitle"]
VERSION_FIELDS = ["description", "keywords", "promotionalText", "whatsNew"]

# States in which Apple still lets metadata be edited.
EDITABLE_STATES = {
    "PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED",
    "METADATA_REJECTED", "INVALID_BINARY", "WAITING_FOR_REVIEW",
}


# ---------------------------------------------------------------- transport


def _b64(data: bytes) -> bytes:
    return base64.urlsafe_b64encode(data).rstrip(b"=")


def make_token() -> str:
    key = serialization.load_pem_private_key(KEY_PATH.read_bytes(), password=None)
    now = int(time.time())
    header = {"alg": "ES256", "kid": KEY_ID, "typ": "JWT"}
    claims = {"iss": ISSUER_ID, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}
    signing_input = _b64(json.dumps(header).encode()) + b"." + _b64(json.dumps(claims).encode())
    der = key.sign(signing_input, ec.ECDSA(hashes.SHA256()))
    r, s = asy_utils.decode_dss_signature(der)
    return (signing_input + b"." + _b64(r.to_bytes(32, "big") + s.to_bytes(32, "big"))).decode()


TOKEN = None


def call(method: str, path: str, body: dict | None = None, **params):
    """One API call. Raises ApiError with Apple's message rather than a bare 409."""
    url = BASE + path
    if params:
        url += "?" + urllib.parse.urlencode(params)
    data = json.dumps(body).encode() if body is not None else None
    request = urllib.request.Request(url, data=data, method=method)
    request.add_header("Authorization", "Bearer " + TOKEN)
    if data:
        request.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(request) as response:
            raw = response.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as exc:
        raise ApiError(exc.code, exc.read().decode("utf-8", "replace")) from None


class ApiError(Exception):
    def __init__(self, status: int, body: str):
        self.status = status
        self.body = body
        try:
            errors = json.loads(body).get("errors", [])
            detail = "; ".join(f"{e.get('title')}: {e.get('detail')}" for e in errors)
        except Exception:
            detail = body[:300]
        super().__init__(f"HTTP {status} — {detail}")


def paged(path: str, **params) -> list:
    """Follow Apple's cursor pagination to the end."""
    out, params = [], {**params, "limit": 200}
    page = call("GET", path, **params)
    while True:
        out.extend(page.get("data", []))
        nxt = page.get("links", {}).get("next")
        if not nxt:
            return out
        page = call("GET", nxt[len(BASE):])


# ---------------------------------------------------------------- targets


def editable_app_info(required: bool) -> str:
    infos = paged(f"/v1/apps/{APP_ID}/appInfos")
    for info in infos:
        if info["attributes"].get("appStoreState") in EDITABLE_STATES:
            return info["id"]
    # Apple is migrating appStoreState → state; fall back to whichever is editable
    # under the newer name before giving up.
    for info in infos:
        if info["attributes"].get("state") in EDITABLE_STATES:
            return info["id"]
    if not required:
        # A dry run before the version exists: the editable app-info record only
        # appears alongside it, so there is nothing to diff against yet.
        return ""
    raise SystemExit(
        "No editable app info record. There is probably no version in "
        "'Prepare for Submission' — create one in App Store Connect, or pass "
        "--create-version X.Y.Z."
    )


def editable_version(create: str | None, apply: bool) -> tuple[str, str, bool]:
    """Return (version id, version string, is_first_version).

    Creating the version is a write, so a dry run must not do it — otherwise
    "show me what you would do" leaves a new version sitting in App Store Connect.
    """
    versions = paged(f"/v1/apps/{APP_ID}/appStoreVersions")
    is_first = len(versions) <= 1

    for version in versions:
        attrs = version["attributes"]
        state = attrs.get("appStoreState") or attrs.get("appVersionState")
        if state in EDITABLE_STATES:
            return version["id"], attrs["versionString"], is_first

    if not create:
        states = ", ".join(
            f"{v['attributes']['versionString']}="
            f"{v['attributes'].get('appStoreState') or v['attributes'].get('appVersionState')}"
            for v in versions
        )
        raise SystemExit(f"No editable version (have: {states}). Pass --create-version X.Y.Z.")

    if not apply:
        print(f"  would create version {create} (dry run — not created)")
        return "", create, False

    created = call("POST", "/v1/appStoreVersions", {
        "data": {
            "type": "appStoreVersions",
            "attributes": {"platform": "IOS", "versionString": create},
            "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}},
        }
    })
    print(f"  created version {create}")
    return created["data"]["id"], create, False


# ---------------------------------------------------------------- writing


def sync(kind: str, existing: dict, locale: str, wanted: dict, parent: tuple[str, str],
         apply: bool) -> str:
    """Create or patch one localization. Returns a one-word outcome for the log."""
    current = existing.get(locale)
    if current is None:
        if not apply:
            return "create"
        parent_type, parent_id = parent
        call("POST", f"/v1/{kind}", {
            "data": {
                "type": kind,
                "attributes": {"locale": locale, **wanted},
                "relationships": {
                    parent_type: {"data": {"type": parent_type + "s", "id": parent_id}}
                },
            }
        })
        return "created"

    changed = {k: v for k, v in wanted.items() if (current["attributes"].get(k) or "") != v}
    if not changed:
        return "same"
    if not apply:
        return "patch:" + ",".join(sorted(changed))
    call("PATCH", f"/v1/{kind}/{current['id']}",
         {"data": {"type": kind, "id": current["id"], "attributes": changed}})
    return "patched:" + ",".join(sorted(changed))


def main() -> int:
    global TOKEN

    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="actually write (default is a dry run)")
    parser.add_argument("--only", help="comma-separated locales to limit the run to")
    parser.add_argument("--create-version", metavar="X.Y.Z",
                        help="create this version first if none is editable")
    args = parser.parse_args()

    listings = load_all()
    if args.only:
        wanted = [l.strip() for l in args.only.split(",")]
        unknown = [l for l in wanted if l not in listings]
        if unknown:
            raise SystemExit(f"unknown locale(s): {', '.join(unknown)}")
        listings = {l: listings[l] for l in wanted}

    if not KEY_PATH.exists():
        raise SystemExit(f"missing API key at {KEY_PATH}")
    TOKEN = make_token()

    mode = "APPLYING" if args.apply else "DRY RUN (nothing is written — pass --apply)"
    print(f"{mode} · {len(listings)} locales\n")

    version_id, version_string, is_first = editable_version(args.create_version, args.apply)
    app_info_id = editable_app_info(required=args.apply)
    print(f"  app info {app_info_id or '(none yet)'} · version {version_string} ({version_id or 'pending'})")
    if is_first:
        print("  first version — release notes are skipped (Apple rejects whatsNew there)")
    print()

    # Creating an app-info localization auto-creates the matching version
    # localization, so the version list is re-read after the first pass rather
    # than trusted from before it.
    app_info_locs = {
        loc["attributes"]["locale"]: loc
        for loc in (paged(f"/v1/appInfos/{app_info_id}/appInfoLocalizations")
                    if app_info_id else [])
    }

    results = {}
    for locale, fields in sorted(listings.items()):
        wanted = {k: fields[k] for k in APP_INFO_FIELDS}
        if locale not in app_info_locs:
            wanted["privacyPolicyUrl"] = PRIVACY_URL
        try:
            results[locale] = [sync("appInfoLocalizations", app_info_locs, locale, wanted,
                                    ("appInfo", app_info_id), args.apply)]
        except ApiError as exc:
            results[locale] = [f"FAILED {exc}"]

    version_locs = {
        loc["attributes"]["locale"]: loc
        for loc in (paged(f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations")
                    if version_id else [])
    }

    for locale, fields in sorted(listings.items()):
        wanted = {k: fields[k] for k in VERSION_FIELDS if not (k == "whatsNew" and is_first)}
        wanted["supportUrl"] = SUPPORT_URL
        wanted["marketingUrl"] = MARKETING_URL
        try:
            results[locale].append(sync("appStoreVersionLocalizations", version_locs, locale,
                                        wanted, ("appStoreVersion", version_id), args.apply))
        except ApiError as exc:
            results[locale].append(f"FAILED {exc}")

    failures = 0
    for locale in sorted(results):
        info, version = results[locale]
        if "FAILED" in info or "FAILED" in version:
            failures += 1
        print(f"  {locale:8}  info: {info:28}  version: {version}")

    print()
    if failures:
        print(f"{failures} locale(s) failed — fix and re-run; successful ones are skipped as 'same'")
        return 1
    if not args.apply:
        print("Dry run only. Re-run with --apply to write.")
    else:
        print("Done. Screenshots stay per-locale — non-localized storefronts fall back to en-US.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
