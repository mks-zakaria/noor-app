"""13-inch iPad App Store set for 1.2, per language: 7 images at 2064x2752.

    python3 make_ipad.py --raw <StoreShotsUITests dir> --posters <LockScreenPosterTests dir>

1-3  the iPad Lock Screen posters (iftar, prayer, suhoor), copied as rendered
4-7  app screens (prayer, Quran, adkar, ibadah) framed with compose() from the iPhone set

Output: ipad/<lang>/13-inch/*.png, the layout push_screenshots.py expects (--dir ipad/<lang>).
"""
import argparse, shutil
from pathlib import Path

HERE = Path(__file__).parent
W, H = 2064, 2752


def load_compose(script: str, arabic: bool):
    if arabic:
        # make_screenshots_ar.py imports these for manual reshaping; Pillow with raqm shapes
        # Arabic natively and shape() is bypassed below, so stubs are enough.
        import sys, types
        for name in ("arabic_reshaper", "bidi", "bidi.algorithm"):
            m = sys.modules.setdefault(name, types.ModuleType(name))
            m.reshape = lambda t: t
            m.get_display = lambda t: t
        sys.modules["bidi"].algorithm = sys.modules["bidi.algorithm"]
    src = (HERE / script).read_text().split("SHOTS = [")[0]
    ns = {"__file__": str(HERE / script)}
    exec(compile(src, script, "exec"), ns)
    if arabic:
        ns["shape"] = lambda t: t  # PIL with raqm shapes Arabic itself (see make_ar_v2.py)
    return lambda raw, title, sub, out, w, h: compose_ipad(ns, arabic, raw, title, sub, out, w, h)


def compose_ipad(ns, arabic, raw_path, headline, subtitle, out_path, W, H):
    """compose() from the iPhone set, retuned for the squarer iPad canvas: smaller type
    (the iPhone sizes scale with width and overflow at 2064 px), room for descenders,
    and iPad-like screen corners instead of iPhone ones (which clip the status bar)."""
    from PIL import Image, ImageDraw, ImageFilter
    font = ns["afont"] if arabic else ns["font"]
    canvas = ns["soft_glow"](ns["gradient"](W, H, ns["GREEN_TOP"], ns["GREEN_BOT"]), W, H)
    d = ImageDraw.Draw(canvas)
    cx = W // 2
    hf, sf = font(int(W * 0.056), "Bold"), font(int(W * 0.028), "Regular")
    y = int(H * 0.05)
    lines, cur = [], ""
    for w in headline.split():
        test = (cur + " " + w).strip()
        if d.textlength(test, font=hf) <= W * 0.86:
            cur = test
        else:
            lines.append(cur); cur = w
    lines.append(cur)
    for ln in lines:
        top, bottom = d.textbbox((0, 0), ln, font=hf)[1::2]
        d.text((cx, y - top), ln, font=hf, fill=ns["WHITE"], anchor="ma")
        y += (bottom - top) + int(H * 0.012)
    y += int(H * 0.012)
    d.rounded_rectangle([cx - int(W * 0.04), y, cx + int(W * 0.04), y + int(H * 0.003)], radius=4, fill=ns["GOLD"])
    y += int(H * 0.02)
    top, bottom = d.textbbox((0, 0), subtitle, font=sf)[1::2]
    d.text((cx, y - top), subtitle, font=sf, fill=(206, 226, 216), anchor="ma")
    y += (bottom - top) + int(H * 0.035)

    shot = Image.open(raw_path).convert("RGB")
    target_w = int(W * 0.76)
    shot = shot.resize((target_w, int(shot.height * target_w / shot.width)), Image.LANCZOS)
    radius, bezel = int(target_w * 0.03), int(target_w * 0.018)
    shot_r = ns["rounded"](shot, radius)
    bw, bh = target_w + bezel * 2, shot.height + bezel * 2
    frame = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle([0, 0, bw - 1, bh - 1], radius=radius + bezel, fill=(18, 22, 20, 255))
    frame.paste(shot_r, (bezel, bezel), shot_r)
    fx = (W - bw) // 2
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([fx, y + 30, fx + bw, y + bh + 30], radius=radius + bezel, fill=(0, 0, 0, 120))
    canvas = Image.alpha_composite(canvas.convert("RGBA"), shadow.filter(ImageFilter.GaussianBlur(44)))
    canvas.paste(frame, (fx, y), frame)  # the device runs off the bottom, like the iPhone set
    canvas.convert("RGB").save(out_path, "PNG")


CAPTIONS = {
    "en": [("1-home", "Never miss a prayer", "Accurate times for your exact location"),
           ("2-quran", "The whole Quran, offline", "114 surahs · translation · search"),
           ("3-adkar", "Adkar for every moment", "Morning, evening & the full Hisn al-Muslim"),
           ("4-ibadah", "Track every prayer", "Prayer log, Qada, Khatmah and Tasbih")],
    "fr": [("1-home", "Ne manquez plus une prière", "Des heures précises pour votre position"),
           ("2-quran", "Tout le Coran, hors connexion", "114 sourates · traduction · recherche"),
           ("3-adkar", "Des adkar pour chaque moment", "Matin, soir et tout le Hisn al-Muslim"),
           ("4-ibadah", "Suivez chaque prière", "Suivi, qada, khatma et tasbih")],
    "ar": [("1-home", "لا تفوّتك صلاة", "مواقيت دقيقة أينما كنت"),
           ("2-quran", "القرآن كاملًا دون إنترنت", "١١٤ سورة، ترجمة، وبحث"),
           ("3-adkar", "أذكار لكل لحظة", "الصباح والمساء وحصن المسلم كاملًا"),
           ("4-ibadah", "تابع صلواتك", "سجلّ الصلاة والقضاء والختمة والمسبحة")],
}
POSTERS = ["1-iftar", "2-prayer", "3-suhoor"]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", required=True, type=Path)
    ap.add_argument("--posters", required=True, type=Path)
    args = ap.parse_args()
    latin = load_compose("make_screenshots.py", arabic=False)
    arabic = load_compose("make_screenshots_ar.py", arabic=True)
    for lang, shots in CAPTIONS.items():
        out = HERE / "ipad" / lang / "13-inch"
        out.mkdir(parents=True, exist_ok=True)
        for p in POSTERS:
            shutil.copyfile(args.posters / f"ipad-{lang}-{p}.png", out / f"{p}.png")
        compose = arabic if lang == "ar" else latin
        for i, (raw, title, sub) in enumerate(shots, start=4):
            name = f"{i}-{raw.split('-', 1)[1]}.png"
            compose(args.raw / f"{lang}-{raw}.png", title, sub, out / name, W, H)
        print(lang, sorted(f.name for f in out.iterdir()))


if __name__ == "__main__":
    main()
