from pathlib import Path
HERE = Path(__file__).parent
src = (HERE / "make_screenshots_ar.py").read_text().split("SHOTS = [")[0]
ns = {"__file__": str(HERE / "make_screenshots_ar.py")}
exec(compile(src, "make_screenshots_ar.py", "exec"), ns)
# This PIL has raqm/harfbuzz → it shapes Arabic natively. Skip manual reshape+bidi
# (which double-processes and breaks the text). Pass raw text through.
ns["shape"] = lambda t: t
compose = ns["compose"]

RAW = HERE / "screenshots-ar-new"
OUT = HERE / "marketing-ar-new"
SIZES = {"6.5-inch": (1284, 2778), "6.9-inch": (1320, 2868)}
SHOTS = [
    ("1-home.png",  "لا تفوّتك صلاة",            "مواقيت دقيقة أينما كنت",                "1-prayer.png"),
    ("2-quran.png", "القرآن كاملًا مع التلاوة",   "١١٤ سورة، ترجمة، وقراءة دون إنترنت",   "2-quran.png"),
    ("3-adkar.png", "أذكار لكل لحظة",            "الصباح والمساء وحصن المسلم كاملًا",      "3-adkar.png"),
    ("4-wird.png",  "وردك اليومي",               "قائمة تتجدّد كل صباح",                  "4-wird.png"),
]
for label,(W,H) in SIZES.items():
    d = OUT/label; d.mkdir(parents=True, exist_ok=True)
    for raw,hl,sub,out in SHOTS:
        compose(RAW/raw, hl, sub, d/out, W, H)
        print("wrote", label, out)
