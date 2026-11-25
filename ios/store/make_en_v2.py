import importlib.util, sys
from pathlib import Path
HERE = Path(__file__).parent
spec = importlib.util.spec_from_file_location("mk", HERE / "make_screenshots.py")
# We can't import (it runs on import). Instead exec its funcs by reading source minus the trailing loop.
src = (HERE / "make_screenshots.py").read_text()
src = src.split("SHOTS = [")[0]  # drop original SHOTS + loop
ns = {"__file__": str(HERE / "make_screenshots.py")}
exec(compile(src, "make_screenshots.py", "exec"), ns)
compose = ns["compose"]

RAW = HERE / "screenshots-new"
OUT = HERE / "marketing-new"
SIZES = {"6.5-inch": (1284, 2778), "6.9-inch": (1320, 2868)}
SHOTS = [
    ("1-home.png",  "Never miss a prayer",          "Accurate times for your exact location",       "1-prayer.png"),
    ("2-quran.png", "The whole Quran, with audio",  "114 surahs · translation · offline reading", "2-quran.png"),
    ("3-adkar.png", "Adkar for every moment",       "Morning, evening & the full Hisn al-Muslim",   "3-adkar.png"),
    ("4-wird.png",  "Build a daily habit",          "A wird checklist that resets each morning",    "4-wird.png"),
]
for label,(W,H) in SIZES.items():
    d = OUT/label; d.mkdir(parents=True, exist_ok=True)
    for raw,hl,sub,out in SHOTS:
        compose(RAW/raw, hl, sub, d/out, W, H)
        print("wrote", label, out)
