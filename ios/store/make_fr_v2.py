"""Compose the French App Store screenshots.

Mirrors make_en_v2.py: reuses compose() from make_screenshots.py (LTR, so the
English compositor is correct for French) and only swaps the raws and captions.
Raws come from screenshots-fr-new, captured with the app's own language set to
French, 24-hour time, and the 9:41 status bar override.
"""
import importlib.util, sys
from pathlib import Path

HERE = Path(__file__).parent
src = (HERE / "make_screenshots.py").read_text().split("SHOTS = [")[0]
ns = {"__file__": str(HERE / "make_screenshots.py")}
exec(compile(src, "make_screenshots.py", "exec"), ns)
compose = ns["compose"]

RAW = HERE / "screenshots-fr-new"
OUT = HERE / "marketing-fr-new"
SIZES = {"6.5-inch": (1284, 2778), "6.9-inch": (1320, 2868)}
SHOTS = [
    ("1-home.png",  "Ne manquez plus une prière",  "Des heures précises pour votre position",   "1-prayer.png"),
    ("2-quran.png", "Tout le Coran, avec l'audio", "114 sourates · traduction · hors connexion", "2-quran.png"),
    ("3-adkar.png", "Des adkar pour chaque moment", "Matin, soir et tout le Hisn al-Muslim",     "3-adkar.png"),
    ("4-wird.png",  "Installez une habitude",      "Un wird qui se réinitialise chaque matin",   "4-wird.png"),
]
for label, (W, H) in SIZES.items():
    d = OUT / label
    d.mkdir(parents=True, exist_ok=True)
    for raw, hl, sub, out in SHOTS:
        compose(RAW / raw, hl, sub, d / out, W, H)
        print("wrote", label, out)
