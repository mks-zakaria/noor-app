"""Mac App Store screenshot of the desktop prayer widget: 2880x1800, English.

    python3 make_mac_widgets.py --raw <DesktopWidgetRenderTests output at scale 4>

Raw files: en-large.png, en-medium.png, en-small.png, ar-small.png (NOOR_DESKTOP_SCALE=4).
Output: mac/en/desktop/5-widgets.png, beside the four window shots from make_mac.py.
"""
import argparse
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

HERE = Path(__file__).parent
W, H = 2880, 1800

src = (HERE / "make_screenshots.py").read_text().split("SHOTS = [")[0]
ns = {"__file__": str(HERE / "make_screenshots.py")}
exec(compile(src, "make_screenshots.py", "exec"), ns)
font = ns["font"]


def wallpaper():
    """A quiet night-blue desktop, so the green widgets stand out (they vanish on green)."""
    top, bottom = (16, 24, 40), (10, 44, 52)
    img = Image.new("RGB", (W, H))
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / H
        d.line([(0, y), (W, y)], fill=tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3)))
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(glow).ellipse([W * 0.55, -H * 0.3, W * 1.25, H * 0.6], fill=(233, 201, 122, 40))
    return Image.alpha_composite(img.convert("RGBA"), glow.filter(ImageFilter.GaussianBlur(220)))


def place(canvas, img, x, y, scale):
    img = img.resize((int(img.width * scale), int(img.height * scale)), Image.LANCZOS)
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([x, y + 24, x + img.width, y + img.height + 24], radius=int(60 * scale), fill=(0, 0, 0, 150))
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(40)))
    canvas.alpha_composite(img, (x, y))
    return canvas, img.size


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", required=True, type=Path)
    args = ap.parse_args()
    raw = {n: Image.open(args.raw / f"{n}.png").convert("RGBA") for n in ("en-large", "en-medium", "en-small", "ar-small")}

    canvas = wallpaper()
    d = ImageDraw.Draw(canvas)
    title, sub = "Prayer times on your desktop", "Three widget sizes, always in step with the app"
    hf, sf = font(118, "Bold"), font(58, "Regular")
    d.text((W // 2, 96), title, font=hf, fill=(247, 250, 248), anchor="ma")
    tb = d.textbbox((W // 2, 96), title, font=hf, anchor="ma")   # real ink box, descenders included
    y = tb[3] + 30
    d.rounded_rectangle([W // 2 - 110, y, W // 2 + 110, y + 8], radius=4, fill=(224, 184, 95))
    d.text((W // 2, y + 40), sub, font=sf, fill=(206, 226, 216), anchor="ma")

    s = 0.82                     # scale-4 renders → about 1.64x the widgets' real size
    gap = 64
    top = 430
    large_w = int(raw["en-large"].width * s)
    right_w = int(raw["en-medium"].width * s)
    x0 = (W - (large_w + gap + right_w)) // 2
    canvas, (lw, lh) = place(canvas, raw["en-large"], x0, top, s)
    x1 = x0 + lw + gap
    canvas, (mw, mh) = place(canvas, raw["en-medium"], x1, top, s)
    small = raw["en-small"]
    ss = (mw - gap) / 2 / small.width     # two small widgets fill the medium's width
    canvas, (sw, sh) = place(canvas, raw["en-small"], x1, top + mh + gap, ss)
    canvas, _ = place(canvas, raw["ar-small"], x1 + sw + gap, top + mh + gap, ss)

    out = HERE / "mac" / "en" / "desktop"
    out.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(out / "5-widgets.png")
    print("wrote", out / "5-widgets.png", "bottom edge", top + max(lh, mh + gap + sh), "of", H)


if __name__ == "__main__":
    main()
