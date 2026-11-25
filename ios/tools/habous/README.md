# Moroccan official prayer times (Ministry of Habous)

Noor's "Morocco (Habous)" method (`Sources/Shared/HabousTimes.swift`) reproduces the ministry's timetable.
It uses the ministry's own rules, recovered from the tables it publishes. Run these steps from this folder.

## Source

**Where the data comes from:** https://www.habous.gov.ma loads `data/horaires-YYYY-MM.js` for the current month.
- It covers 190 cities, with times in Moroccan legal time.
- Moroccan legal time has been GMT since 20 Sep 2026 (decree 2.26.530).
- Only the current month and the previous one are online. The next month appears around the last day of the month.
- `horaires-2026-10.json` and `horaires-2026-11.json` are the files from 2026-11-22, converted to JSON.

## The rules (fitted by `fit_all.py`)

| Prayer | Rule |
|---|---|
| Fajr | sun at −19°, truncated to the minute (offset −0.5 then rounded) |
| Sunrise | sun at −(city's east horizon), offset −0.24 min |
| Dhuhr | transit + 5 min |
| Asr | shadow = 1 + noon shadow, +0.2 min |
| Maghrib | sun at −(city's west horizon), +1.02 min |
| Isha | sun at −17° |

**Rounding:** everything is rounded to the nearest minute.

**Horizons:** each city's east and west horizon depressions are fitted separately, from 0.83° on a flat coast up to about 3° in the mountains.

**City positions:** the ministry doesn't publish coordinates. Each city's position is fitted on its own timetable: Dhuhr gives the longitude, and Fajr, Asr and Isha give the latitude. The geocoder is used only as a hint, because it put Laayoune and Dakhla in the wrong places.

## Result

On 190 cities × 61 days (11,590 city-days), each prayer matches the ministry to the minute on 96–98% of days and is never off by more than 1 minute.

**Known trade-off:** Maghrib is 1 minute early on 1.3% of days. A Maghrib offset of +1.10 would bring that to 0.09%, but exact matches would fall to 91%.

## Each month (5 minutes)

1. Download the new month:
   ```sh
   curl -A "Mozilla/5.0" https://www.habous.gov.ma/data/horaires-2026-12.js
   ```
2. Convert it to JSON, the same way as the existing files.
3. Check that the model still matches. `PrayerAccuracyTests.testHabousOfficialTable` does this for November. Re-running `fit_all.py` with the new month added refines the horizons.
4. If the ministry changes its method, the match rate drops. Re-fit, and copy the new `habous-cities.json` into `Resources/Morocco/`.
