"""Mac App Store set (English): the Mac window on a 2880x1800 canvas with a headline.

    python3 make_mac.py --raw <dir with mac-en-0.png, mac-en-2.png, mac-en-3.png, mac-en-4.png>

The raw files are `screencapture -o -l <window>` captures of the Debug Mac app launched with
`-demoLocation -tab <n>` (0 prayer, 2 Quran, 3 adkar, 4 ibadah). Output: mac/en/desktop/*.png,
the layout push_screenshots.py expects.
"""
import argparse
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

HERE = Path(__file__).parent
W, H = 2880, 1800

src = (HERE / "make_screenshots.py").read_text().split("SHOTS = [")[0]
ns = {"__file__": str(HERE / "make_screenshots.py")}
exec(compile(src, "make_screenshots.py", "exec"), ns)

SHOTS = [("0", "Never miss a prayer", "Accurate times for your city, on your Mac", "1-prayer.png"),
         ("2", "The whole Quran, offline", "114 surahs · translation · search", "2-quran.png"),
         ("3", "Adkar for every moment", "Morning, evening & the full Hisn al-Muslim", "3-adkar.png"),
         ("4", "Track every prayer", "Prayer log, Qada, Khatmah and Tasbih", "4-ibadah.png")]


def compose(raw: Path, title: str, sub: str, out: Path):
    canvas = ns["soft_glow"](ns["gradient"](W, H, ns["GREEN_TOP"], ns["GREEN_BOT"]), W, H).convert("RGBA")
    d = ImageDraw.Draw(canvas)
    hf, sf = ns["font"](118, "Bold"), ns["font"](58, "Regular")
    y = 110
    top, bottom = d.textbbox((0, 0), title, font=hf)[1::2]
    d.text((W // 2, y - top), title, font=hf, fill=ns["WHITE"], anchor="ma")
    y += bottom - top + 36
    d.rounded_rectangle([W // 2 - 110, y, W // 2 + 110, y + 8], radius=4, fill=ns["GOLD"])
    y += 40
    top, bottom = d.textbbox((0, 0), sub, font=sf)[1::2]
    d.text((W // 2, y - top), sub, font=sf, fill=(206, 226, 216), anchor="ma")
    y += bottom - top + 80

    win = Image.open(raw).convert("RGBA")
    scale = min(W * 0.8 / win.width, (H - y - 60) / win.height)
    win = win.resize((int(win.width * scale), int(win.height * scale)), Image.LANCZOS)
    x = (W - win.width) // 2
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([x, y + 30, x + win.width, y + win.height + 30], radius=40, fill=(0, 0, 0, 130))
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(50)))
    canvas.alpha_composite(win, (x, y))
    canvas.convert("RGB").save(out, "PNG")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", required=True, type=Path)
    args = ap.parse_args()
    out = HERE / "mac" / "en" / "desktop"
    out.mkdir(parents=True, exist_ok=True)
    for tab, title, sub, name in SHOTS:
        compose(args.raw / f"mac-en-{tab}.png", title, sub, out / name)
        print("wrote", out / name)


if __name__ == "__main__":
    main()
