"""Compose polished App Store marketing screenshots for Noor, at every iPhone size.

Wraps each raw iPhone capture in a device bezel over a brand-green gradient with a
headline + subtitle. Layout is proportional so it renders correctly at any canvas
size. Output is flattened to RGB (no alpha — App Store rejects alpha in screenshots).

Sizes rendered (portrait):
  6.9" -> 1320x2868   (iPhone 16/17 Pro Max)
  6.5" -> 1284x2778   (iPhone 14 Pro Max etc. — the size the ASC slot asked for)

Usage: python3 make_screenshots.py
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE = Path(__file__).parent
RAW = HERE / "screenshots"
OUT = HERE / "marketing"

# Brand palette (from AppIcon + Theme.swift)
GREEN_TOP = (16, 122, 95)     # #107A5F
GREEN_BOT = (8, 66, 50)       # deep emerald
GOLD = (224, 184, 95)         # #E0B85F
WHITE = (247, 250, 248)       # #F7FAF8

FONT = "/System/Library/Fonts/SFNS.ttf"
FONT_FALLBACK_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
FONT_FALLBACK = "/System/Library/Fonts/Supplemental/Arial.ttf"

SIZES = {
    "6.9-inch": (1320, 2868),
    "6.5-inch": (1284, 2778),
}


def font(size, weight="Bold"):
    try:
        f = ImageFont.truetype(FONT, size)
        try:
            f.set_variation_by_name(weight)
        except Exception:
            pass
        return f
    except OSError:
        path = FONT_FALLBACK_BOLD if weight in ("Bold", "Semibold", "Heavy") else FONT_FALLBACK
        return ImageFont.truetype(path, size)


def gradient(W, H, top, bot):
    base = Image.new("RGB", (W, H), top)
    d = ImageDraw.Draw(base)
    for y in range(H):
        t = (y / (H - 1)) ** 1.15
        d.line([(0, y), (W, y)],
               fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bot)))
    return base


def soft_glow(img, W, H):
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse([W * 0.1, -H * 0.12, W * 0.9, H * 0.28], fill=70)
    glow = glow.filter(ImageFilter.GaussianBlur(int(W * 0.12)))
    img.paste(Image.new("RGB", (W, H), (150, 200, 175)), (0, 0), glow)
    return img


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, img.size[0] - 1, img.size[1] - 1],
                                           radius=radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def draw_center(d, cx, y, text, fnt, fill):
    l, t, r, b = d.textbbox((0, 0), text, font=fnt)
    d.text((cx - (r - l) / 2, y), text, font=fnt, fill=fill)
    return b - t


def compose(raw_path, headline, subtitle, out_path, W, H):
    canvas = soft_glow(gradient(W, H, GREEN_TOP, GREEN_BOT), W, H)
    d = ImageDraw.Draw(canvas)
    cx = W // 2

    hf = font(int(W * 0.073), "Bold")        # ~96 at 1320
    sf = font(int(W * 0.035), "Regular")     # ~46 at 1320

    words = headline.split()
    lines, cur = [], ""
    for w in words:
        test = (cur + " " + w).strip()
        if d.textlength(test, font=hf) <= W - int(W * 0.15):
            cur = test
        else:
            lines.append(cur); cur = w
    if cur:
        lines.append(cur)

    y = int(H * 0.052)
    for ln in lines:
        y += draw_center(d, cx, y, ln, hf, WHITE) + int(H * 0.008)

    y += int(H * 0.004)
    d.rounded_rectangle([cx - int(W * 0.045), y, cx + int(W * 0.045), y + int(H * 0.0028)],
                        radius=4, fill=GOLD)
    y += int(H * 0.015)
    draw_center(d, cx, y, subtitle, sf, (206, 226, 216))
    y += int(H * 0.035)

    # --- Device frame ---
    shot = Image.open(raw_path).convert("RGB")
    target_w = int(W * 0.712)
    shot = shot.resize((target_w, int(shot.height * target_w / shot.width)), Image.LANCZOS)
    target_h = shot.height

    screen_radius = int(target_w * 0.083)
    shot_r = rounded(shot, screen_radius)
    bezel = int(target_w * 0.023)
    bw, bh = target_w + bezel * 2, target_h + bezel * 2

    frame = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle([0, 0, bw - 1, bh - 1],
                                            radius=screen_radius + bezel, fill=(18, 22, 20, 255))
    frame.paste(shot_r, (bezel, bezel), shot_r)

    fx, fy = (W - bw) // 2, y
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([fx, fy + 26, fx + bw, fy + bh + 26],
                                             radius=screen_radius + bezel, fill=(0, 0, 0, 120))
    shadow = shadow.filter(ImageFilter.GaussianBlur(40))
    canvas = Image.alpha_composite(canvas.convert("RGBA"), shadow)
    canvas.paste(frame, (fx, fy), frame)
    canvas.convert("RGB").save(out_path, "PNG")


SHOTS = [
    ("1-home.png",  "Never miss a prayer",         "Accurate adhan times for your exact location", "1-prayer.png"),
    ("2-quran.png", "The whole Quran, with audio", "114 surahs · translation · offline reading",   "2-quran.png"),
    ("3-adkar.png", "Morning & evening adkar",      "Remembrance to carry you through the day",     "3-adkar.png"),
]

for label, (W, H) in SIZES.items():
    d = OUT / label
    d.mkdir(parents=True, exist_ok=True)
    for raw, hl, sub, out in SHOTS:
        compose(RAW / raw, hl, sub, d / out, W, H)
        print(f"wrote {label}/{out}  ({W}x{H})")
