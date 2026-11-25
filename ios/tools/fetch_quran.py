#!/usr/bin/env python3
"""Download the Quran text once and write compact JSON bundled with the app.

Source: AlQuran Cloud API (https://alquran.cloud/api), editions:
  quran-uthmani  - Tanzil Uthmani text (Tanzil licence: verbatim copies, keep source credit)
  en.sahih       - Saheeh International
  fr.hamidullah  - Muhammad Hamidullah
Output (Resources/Quran/):
  quran-meta.json - per ayah [surah, ayah, juz, page, hizbQuarter], in mushaf order (6236 rows)
  quran-ar.json  - list of 114 lists of ayah texts
  quran-en.json, quran-fr.json - same shape as ar.json
Run from noor/app/ios:  python3 tools/fetch_quran.py
"""
import json, os, sys, urllib.request

OUT = os.path.join(os.path.dirname(__file__), "..", "Resources", "Quran")
def bare(word):
    """Letters only: drops tashkeel and Quranic marks so spelling variants compare equal."""
    return "".join(c for c in word if not ("\u064b" <= c <= "\u065f" or c in "\u0670\u06d6\u06d7\u06d8\u06d9\u06da\u06db\u06dc\u06df\u06e0\u06e1\u06e2\u06e3\u06e4\u06e5\u06e6\u06e7\u06e8\u06ea\u06eb\u06ec\u06ed")).replace("\u0671", "\u0627")

def is_basmala(words):
    return [bare(w) for w in words] == ["بسم", "الله", "الرحمن", "الرحيم"]

EDITIONS = {"ar": "quran-uthmani", "en": "en.sahih", "fr": "fr.hamidullah"}

def get(edition):
    url = f"https://api.alquran.cloud/v1/quran/{edition}"
    req = urllib.request.Request(url, headers={"User-Agent": "noor-build"})
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.load(r)["data"]["surahs"]

def main():
    os.makedirs(OUT, exist_ok=True)
    meta = None
    for code, edition in EDITIONS.items():
        surahs = get(edition)
        assert len(surahs) == 114, edition
        texts = [[a["text"].replace("\ufeff", "") for a in s["ayahs"]] for s in surahs]
        if code == "ar":
            # The Uthmani edition prefixes ayah 1 of every surah (except 1 and 9)
            # with the basmala; the reader already shows it in the surah header.
            for i, ayahs in enumerate(texts):
                n = i + 1
                words = ayahs[0].split(" ")
                if n not in (1, 9) and is_basmala(words[:4]):
                    ayahs[0] = " ".join(words[4:])
        assert sum(map(len, texts)) == 6236, edition
        if code == "ar":
            meta = [[s["number"], a["numberInSurah"], a["juz"], a["page"], a["hizbQuarter"]]
                    for s in surahs for a in s["ayahs"]]
        with open(os.path.join(OUT, f"quran-{code}.json"), "w", encoding="utf-8") as f:
            json.dump(texts, f, ensure_ascii=False, separators=(",", ":"))
        print(code, "ok")
    with open(os.path.join(OUT, "quran-meta.json"), "w") as f:
        json.dump(meta, f, separators=(",", ":"))
    print("pages", max(m[3] for m in meta), "juz", max(m[2] for m in meta))

if __name__ == "__main__":
    sys.exit(main())
