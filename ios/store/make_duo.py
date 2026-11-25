"""iPhone Duo App Store set (APP_IPHONE_DUO): 4 framed app screens, English and Arabic.

    python3 make_duo.py

Raw captures in duo/raw/ come from the TourUITests run on the iPhone Duo simulator
(iOS 27.2 Duo runtime 24B91016s, inner display 1398x2034). French listings fall back to the
English Duo set. Same composer as the iPad set (make_ipad.py). Output: duo/<lang>/duo/*.png.
"""
from pathlib import Path
from PIL import Image

import make_ipad

HERE = Path(__file__).parent
CAPTIONS = {
    "en": [("01-home", "Never miss a prayer", "Accurate times for your exact location"),
           ("03-ramadan", "Ready for Ramadan", "Suhoor and iftar countdown, timetable, du'as"),
           ("09-quran-juz", "The whole Quran, offline", "114 surahs · 30 juz · search"),
           ("06-ibadah", "Track every prayer", "Prayer log, Qada, Khatmah and Tasbih")],
    "ar": [("01-home", "لا تفوّتك صلاة", "مواقيت دقيقة أينما كنت"),
           ("03-ramadan", "استعدّ لرمضان", "عدّ تنازلي للسحور والإفطار، إمساكية، أدعية"),
           ("09-quran-juz", "القرآن كاملًا دون إنترنت", "١١٤ سورة، ٣٠ جزءًا، وبحث"),
           ("06-ibadah", "تابع صلواتك", "سجلّ الصلاة والقضاء والختمة والمسبحة")],
}


def main():
    latin = make_ipad.load_compose("make_screenshots.py", arabic=False)
    arabic = make_ipad.load_compose("make_screenshots_ar.py", arabic=True)
    for lang, shots in CAPTIONS.items():
        out = HERE / "duo" / lang / "duo"
        out.mkdir(parents=True, exist_ok=True)
        compose = arabic if lang == "ar" else latin
        for i, (raw, title, sub) in enumerate(shots, start=1):
            src = HERE / "duo" / "raw" / f"{lang}-{raw}.png"
            w, h = Image.open(src).size
            compose(src, title, sub, out / f"{i}-{raw.split('-', 1)[1]}.png", w, h)
        print(lang, sorted(f.name for f in out.iterdir()))


if __name__ == "__main__":
    main()
