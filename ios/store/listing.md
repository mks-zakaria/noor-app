# Noor — App Store listing

**Category:** Lifestyle (secondary: Reference) · **Age:** 4+ · **Price:** Free
- Primary Lifestyle because Apple files religion and daily-practice apps (prayer times, devotionals) under Lifestyle; Reference is secondary for the Quran text and worship guides.
- **Privacy Policy URL:** https://mks-zakaria.github.io/noor/privacy.html *(must be live before submission — see note below)*
- **Support URL:** https://mks-zakaria.github.io/noor/support.html *(or reuse the rush-games support page style)*
- **Contact email:** makhkhas.zakaria@gmail.com
- **Copyright:** 2026 zakaria makhkhas

> **Before submitting:** The privacy policy (from `PRIVACY.md`) is published as HTML at the Privacy Policy URL above via GitHub Pages, alongside a Support page. Confirm both URLs load, then paste them into App Store Connect. (The critical-alerts / "override silent mode" feature was removed for v1.0 since it needs a pending Apple entitlement; it can return in a later version once approved.)

## App Store

- **Name (≤30):** `Noor — Prayer Times & Qibla` <!-- 27/30 -->
  - Alternate if taken: `Noor: Muslim Prayer & Quran` <!-- 27/30 -->
- **Subtitle (≤30):** `Adhan, Quran, Adkar & Compass` <!-- 29/30 -->
- **Promotional text (≤170):** `This update brings your lock-screen widget to life in your language — Arabic, English, or both. Prayer times, Qibla, Quran and adkar, always one glance away.` <!-- 157/170 -->
- **Keywords (≤100):** `salah,muslim,islam,athan,azan,ramadan,hijri,dua,dhikr,fajr,namaz,salat,mosque,sunnah,tasbih,eid` <!-- 95/100; no repeats of name/subtitle words (noor, prayer, times, qibla, adhan, quran, adkar, compass) -->
- **Description:** <!-- 2044/3000 -->
```
Noor brings your daily worship into one quiet, beautiful place: accurate prayer times, a Qibla compass, the complete Quran, and the remembrances that carry you through the day.

Prayer times are calculated on your device from your location using the trusted Adhan engine — no account, no server, no tracking. Choose from twelve calculation methods (Muslim World League, Umm al-Qura, ISNA, Egyptian, Karachi, Diyanet, and more) and the Hanafi or Shafi/Maliki/Hanbali madhab so the times match your local mosque. The home screen shows today's Hijri and Gregorian dates, a live countdown to the next prayer, sunrise, and the last third of the night.

PRAYER & NOTIFICATIONS
• Adhan notifications for each prayer — pick exactly which prayers notify
• Adhan sound on or off for prayer reminders
• Hijri date with a manual day adjustment for local moon sighting

QIBLA
• A clean compass that points to the Kaaba from wherever you are

QURAN
• All 114 surahs in Uthmani Arabic script with Sahih International (English) or Hamidullah (French) translation
• Audio recitation by Mishary Rashid Alafasy
• Bookmarks, a continue-reading card, search, and adjustable Arabic text size
• Surahs you open are cached, so re-reading works offline

ADKAR & DAILY WIRD
• Morning and evening adkar with Arabic, transliteration, and translation
• Tap-to-count repeat counters and favourites
• Du'as for provision, distress and anxiety, and fulfilling a need
• A daily wird checklist — prayers, Quran, istighfar, salawat — that resets each morning
• Optional morning and evening adkar reminders

LEARN
• Step-by-step guides: wudu, ghusl, how to pray, rak'ah counts, witr, duha, tahajjud, jumu'ah, Eid, janazah, tarawih, istikhara, the traveller's prayer, and more

Noor speaks English, French, and Arabic (with full right-to-left layout), offers light and dark themes, and collects no data whatsoever. Your location never leaves your phone.

May it help you keep your prayers on time and your heart in remembrance.
```
- **What's New (v1.1.1):** `The lock-screen widget now matches your app language and lets you choose Arabic, English, or both for the nightly verse.` <!-- 137/4000 -->

## App Privacy (App Store Connect questionnaire)

- **Answer: Data Not Collected.**
- Evidence: the only network calls in the sources are read-only content fetches in `Sources/Features/Quran/QuranService.swift` (Quran text from api.alquran.cloud, recitation audio from mp3quran.net — no user data in either request); location is consumed on-device by the Adhan library (`PrayerService.swift`) and CoreLocation reverse geocoding, never transmitted; there are no analytics or third-party SDKs (the only dependency is adhan-swift).
- Location permission: `NSLocationWhenInUseUsageDescription` — "Noor uses your location to calculate accurate prayer times and the Qibla direction."
- Notifications are local (`UNUserNotificationCenter`), no push/APNs server.

## Age rating

4+ — no objectionable content, no user-generated content, no web browsing, no ads, no in-app purchases.
