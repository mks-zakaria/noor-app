#!/usr/bin/env python3
"""Upload an App Preview video (App Store autoplaying video) to the editable version, per locale.

    python3 push_previews.py --locale ar-SA --file ../../../../content/promo/previews/noor-preview-ar.mp4 --apply

Puts the video in the iPhone 6.9" (IPHONE_67) and 6.5" (IPHONE_65) preview sets — both take 886 x 1920 —
replacing any preview already there with the same file name. Same reserve / PUT / commit flow as
push_screenshots.py, retried on this connection's frequent timeouts. Apple then processes the video
(state goes to COMPLETE after a few minutes); the poster frame is set at 1 s.
"""
import argparse, hashlib, pathlib, time, urllib.request
import push
from push import ApiError

PREVIEW_TYPES = ["IPHONE_67", "IPHONE_65"]

def _retry(fn):
    def w(*a, **k):
        for i in range(8):
            try:
                push.TOKEN = push.make_token(); return fn(*a, **k)
            except ApiError: raise
            except Exception as e:
                print("  retry", i + 1, type(e).__name__, flush=True); time.sleep(6 * (i + 1))
        raise SystemExit("network keeps failing")
    return w
call = _retry(push.call); paged = _retry(push.paged)

def localization(version_id, locale):
    for loc in paged(f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations"):
        if loc["attributes"]["locale"] == locale: return loc["id"]
    raise SystemExit(f"no {locale} localization")

def preview_set(loc_id, ptype):
    for s in paged(f"/v1/appStoreVersionLocalizations/{loc_id}/appPreviewSets"):
        if s["attributes"]["previewType"] == ptype: return s["id"]
    return call("POST", "/v1/appPreviewSets", {"data": {"type": "appPreviewSets", "attributes": {"previewType": ptype},
        "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": loc_id}}}}})["data"]["id"]

@_retry
def put_chunk(op, chunk):
    req = urllib.request.Request(op["url"], data=chunk, method=op["method"])
    for h in op.get("requestHeaders", []): req.add_header(h["name"], h["value"])
    with urllib.request.urlopen(req, timeout=300) as r: r.read()

def upload(set_id, path):
    blob = path.read_bytes()
    r = call("POST", "/v1/appPreviews", {"data": {"type": "appPreviews",
        "attributes": {"fileName": path.name, "fileSize": len(blob), "mimeType": "video/mp4", "previewFrameTimeCode": "00:00:01:00"},
        "relationships": {"appPreviewSet": {"data": {"type": "appPreviewSets", "id": set_id}}}}})["data"]
    for op in r["attributes"]["uploadOperations"]:
        put_chunk(op, blob[op["offset"]:op["offset"] + op["length"]])
    call("PATCH", f"/v1/appPreviews/{r['id']}", {"data": {"type": "appPreviews", "id": r["id"],
        "attributes": {"uploaded": True, "sourceFileChecksum": hashlib.md5(blob).hexdigest()}}})
    return r["id"]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--locale", required=True); ap.add_argument("--file", required=True)
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()
    path = pathlib.Path(a.file).resolve()
    push.TOKEN = push.make_token()
    vid, vstr, _ = push.editable_version(None, a.apply)
    loc = localization(vid, a.locale)
    print(("APPLYING" if a.apply else "DRY RUN") + f" · {a.locale} · version {vstr} · {path.name} ({path.stat().st_size // 1024} KB)")
    for ptype in PREVIEW_TYPES:
        sid = preview_set(loc, ptype) if a.apply else "-"
        if not a.apply: print("  would upload to", ptype); continue
        for p in paged(f"/v1/appPreviewSets/{sid}/appPreviews"):   # replace a previous upload of the same video
            if p["attributes"]["fileName"] == path.name:
                call("DELETE", f"/v1/appPreviews/{p['id']}"); print("  replaced old", ptype)
        print("  uploaded", ptype, upload(sid, path), flush=True)

if __name__ == "__main__":
    main()
