"""Arabic marketing screenshots for Noor (RTL captions over Arabic-UI captures).

Same frame design as make_screenshots.py, but captions are Arabic — shaped with
arabic_reshaper + python-bidi (PIL has no raqm here) and drawn with SF Arabic.
Run with the venv:  scratchpad/venv/bin/python make_screenshots_ar.py
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import arabic_reshaper
from bidi.algorithm import get_display

HERE = Path(__file__).parent
RAW = HERE / "screenshots-ar"
OUT = HERE / "marketing-ar"

GREEN_TOP = (16, 122, 95)
GREEN_BOT = (8, 66, 50)
GOLD = (224, 184, 95)
WHITE = (247, 250, 248)

AR_FONT = "/System/Library/Fonts/SFArabic.ttf"
AR_FONT_FALLBACK = "/System/Library/Fonts/GeezaPro.ttc"

SIZES = {"6.9-inch": (1320, 2868), "6.5-inch": (1284, 2778)}


def shape(text):
    return get_display(arabic_reshaper.reshape(text))


def afont(size, weight="Bold"):
    for path in (AR_FONT, AR_FONT_FALLBACK):
        try:
            f = ImageFont.truetype(path, size)
            try:
                f.set_variation_by_name(weight)
            except Exception:
                pass
            return f
        except OSError:
            continue
    raise RuntimeError("no arabic font")


def gradient(W, H, top, bot):
    base = Image.new("RGB", (W, H), top)
    d = ImageDraw.Draw(base)
    for y in range(H):
        t = (y / (H - 1)) ** 1.15
        d.line([(0, y), (W, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bot)))
    return base


def soft_glow(img, W, H):
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse([W * 0.1, -H * 0.12, W * 0.9, H * 0.28], fill=70)
    glow = glow.filter(ImageFilter.GaussianBlur(int(W * 0.12)))
    img.paste(Image.new("RGB", (W, H), (150, 200, 175)), (0, 0), glow)
    return img


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, img.size[0] - 1, img.size[1] - 1], radius=radius, fill=255)
    out = img.convert("RGBA"); out.putalpha(mask); return out


def draw_center(d, cx, y, shaped, fnt, fill):
    l, t, r, b = d.textbbox((0, 0), shaped, font=fnt)
    d.text((cx - (r - l) / 2 - l, y - t), shaped, font=fnt, fill=fill)
    return b - t


def fit_font(d, shaped, maxw, start, weight="Bold"):
    size = start
    while size > 30:
        f = afont(size, weight)
        if d.textlength(shaped, font=f) <= maxw:
            return f
        size -= 4
    return afont(size, weight)


def compose(raw_path, headline, subtitle, out_path, W, H):
    canvas = soft_glow(gradient(W, H, GREEN_TOP, GREEN_BOT), W, H)
    d = ImageDraw.Draw(canvas)
    cx = W // 2
    maxw = W - int(W * 0.13)

    hl, sub = shape(headline), shape(subtitle)
    hf = fit_font(d, hl, maxw, int(W * 0.082), "Bold")
    sf = fit_font(d, sub, maxw, int(W * 0.037), "Regular")

    y = int(H * 0.062)
    y += draw_center(d, cx, y, hl, hf, WHITE) + int(H * 0.012)
    d.rounded_rectangle([cx - int(W * 0.045), y, cx + int(W * 0.045), y + int(H * 0.0028)], radius=4, fill=GOLD)
    y += int(H * 0.016)
    y += draw_center(d, cx, y, sub, sf, (206, 226, 216)) + int(H * 0.03)

    shot = Image.open(raw_path).convert("RGB")
    target_w = int(W * 0.712)
    shot = shot.resize((target_w, int(shot.height * target_w / shot.width)), Image.LANCZOS)
    target_h = shot.height
    screen_radius = int(target_w * 0.083)
    shot_r = rounded(shot, screen_radius)
    bezel = int(target_w * 0.023)
    bw, bh = target_w + bezel * 2, target_h + bezel * 2
    frame = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle([0, 0, bw - 1, bh - 1], radius=screen_radius + bezel, fill=(18, 22, 20, 255))
    frame.paste(shot_r, (bezel, bezel), shot_r)

    fx, fy = (W - bw) // 2, y
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([fx, fy + 26, fx + bw, fy + bh + 26], radius=screen_radius + bezel, fill=(0, 0, 0, 120))
    shadow = shadow.filter(ImageFilter.GaussianBlur(40))
    canvas = Image.alpha_composite(canvas.convert("RGBA"), shadow)
    canvas.paste(frame, (fx, fy), frame)
    canvas.convert("RGB").save(out_path, "PNG")


SHOTS = [
    ("1-home.png",  "لا تفوّتك صلاة",          "مواقيت دقيقة أينما كنت",        "1-prayer.png"),
    ("2-quran.png", "القرآن كاملًا مع التلاوة", "١١٤ سورة، ترجمة، وقراءة دون إنترنت", "2-quran.png"),
    ("3-adkar.png", "أذكار الصباح والمساء",     "ذِكرٌ يرافقك طوال اليوم",       "3-adkar.png"),
]

for label, (W, H) in SIZES.items():
    dst = OUT / label
    dst.mkdir(parents=True, exist_ok=True)
    for raw, hl, sub, out in SHOTS:
        compose(RAW / raw, hl, sub, dst / out, W, H)
        print(f"wrote {label}/{out}")
