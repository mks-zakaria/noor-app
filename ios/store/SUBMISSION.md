# Noor — App Store Submission Checklist

_Prepared 2026-07-13. Consolidates the Snaptle submission lessons + current Apple specs._
_Bundle `com.zakaria.noor` · Team `JF83ACY9N9` · v1.1.1 (build 5) · min iOS 18.0 · iPhone-only_

## Status at a glance

| Item | State |
|------|-------|
| Listing metadata (`listing.md`) | ✅ Ready — names/subtitle/keywords within limits |
| Privacy policy page | ✅ Live — https://mks-zakaria.github.io/noor/privacy.html (200) |
| Support page | ✅ Live — https://mks-zakaria.github.io/noor/support.html (200) |
| App icon 1024² | ✅ No alpha channel |
| Privacy manifest `PrivacyInfo.xcprivacy` | ✅ Correct (no tracking, UserDefaults CA92.1) — ⚠️ see build note |
| Marketing screenshots (6.9") | ✅ 3 × 1320×2868, RGB (no alpha) in `store/marketing/` |
| App Privacy questionnaire answer | ✅ "Data Not Collected" (justified in `listing.md`) |
| Age rating | ✅ 4+ |
| **Fresh archive with manifest** | ✅ **DONE (2026-09-01)** — `build/Noor-1.1.0.xcarchive`, v1.1.1 (5) |
| App Store Connect app record | ✅ Exists — 1.1.0 train is closed, v1.1.1 added |
| Build uploaded | ✅ **DONE (2026-09-01)** — build 5, delivery UUID `d65c25b6-cfab-497e-b69b-f5aa9c3e3b24` |

## ✅ Submission path used (2026-09-01)

1. **Copy-paste metadata** from `listing.md` / `listing-fr.md` / `listing-ar.md`
   (What's New now says **v1.1.1** — widget follows app language + Arabic/English/both choice).
2. **Add build 5 to the v1.1.1 version** in App Store Connect (delivery UUID
   `d65c25b6-cfab-497e-b69b-f5aa9c3e3b24`), attach it, review the export compliance
   question, then submit for review.
3. Build was uploaded with:
   ```sh
   xcrun altool --upload-app -f build/Noor-1.1.0.ipa --type ios \
     --apiKey FRT72JC9WV --apiIssuer c8bca885-6780-4d7c-9b6a-494f61367030
   ```
   Signing: API-minted Apple Distribution cert (`SGSQ9LXR9D`) + profiles
   "Noor App Store" / "NoorWidget App Store", keychain `/tmp/distsign/dist.keychain-db`
   (password `X99noor`; unlock before each archive).
4. The 1.1.0 train is closed — do not reuse 1.1.0 (error 90062). Use 1.1.1+.

## Screenshots

- **Required size:** iPhone 6.9" only (Apple auto-scales down to smaller iPhones).
  Accepted 6.9" dimensions: **1290×2796 or 1320×2868**. Ours are 1320×2868. ✅
- **No alpha channel** (Apple rejects screenshots with alpha) — flattened to RGB. ✅
- 1–10 per size; we ship 3: Prayer, Quran, Adkar.
- Polished set in `store/marketing/` (gradient + caption + device frame).
  Raw captures kept in `store/screenshots/`. Regenerate with `python3 store/make_screenshots.py`.
- Optional later: add Qibla + Wird + Learn shots (needs a device/sim capture; Qibla
  heading doesn't render in the simulator).

## App Review notes (paste into the "Notes" field)

> Noor is a client-side Islamic prayer-times app. It collects no data, has no accounts,
> and contains no login. Prayer times and Qibla are computed on-device from location
> (never transmitted). The only network calls fetch read-only Quran text
> (api.alquran.cloud) and recitation audio (mp3quran.net); no personal data is sent.
> All notifications are local. No demo account is required.

## Copy-paste metadata → see `listing.md`
Name, subtitle, promo text, keywords, description, and What's New are all finalized there.

## Snaptle lessons applied
- Privacy policy + support pages published on GitHub Pages **before** submission (verified 200).
- Privacy manifest bundled and answers match the code (Data Not Collected).
- Icon exported without alpha.
- Screenshots at the single required 6.9" size, no alpha, exact pixel dimensions.
- Removed the Critical Alerts entitlement for v1.0 (needs Apple approval) to avoid a
  signing/review block — can return in a later version.
