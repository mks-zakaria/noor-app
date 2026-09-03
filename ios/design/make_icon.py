import numpy as np
from PIL import Image, ImageFilter

# macOS (Big Sur+) icons are full-bleed squares; the OS applies the rounded
# squircle + drop shadow. Keep the artwork inside a comfortable safe margin so
# the corners never get clipped. Render at 4x for clean AA then downscale.
SS = 4
W = 1024 * SS
def s(v): return v * SS     # logical(1024) -> render coords

def hex2rgb(h):
    h = h.lstrip('#')
    return np.array([int(h[i:i+2], 16) for i in (0, 2, 4)], dtype=float)

def smoothstep(edge0, edge1, x):
    tt = np.clip((x - edge0) / (edge1 - edge0), 0, 1)
    return tt * tt * (3 - 2 * tt)

ys, xs = np.mgrid[0:W, 0:W].astype(float)

# ---- background: diagonal emerald gradient (light corner -> deep corner) ----
c0, c1 = hex2rgb('#12A37E'), hex2rgb('#052E23')
t = (xs + ys) / (2 * W)
img = c0[None, None, :] * (1 - t)[..., None] + c1[None, None, :] * t[..., None]

# ---- soft radial "noor" glow, warm, centered slightly up ----
gcx, gcy, gr = s(512), s(448), s(540)
dist = np.hypot(xs - gcx, ys - gcy)
glow_a = (1 - smoothstep(0, gr, dist)) * 0.55
glow_col = hex2rgb('#FFEFC2')
img = img * (1 - glow_a[..., None]) + glow_col[None, None, :] * glow_a[..., None]

# ---- vertical gold gradient (fill for the glyph) ----
gt = np.clip(ys / W, 0, 1)
gold_top, gold_mid, gold_bot = hex2rgb('#F7DF92'), hex2rgb('#E9C467'), hex2rgb('#C99A3B')
gold = np.where(
    (gt < 0.5)[..., None],
    gold_top[None, None, :] * (1 - gt * 2)[..., None] + gold_mid[None, None, :] * (gt * 2)[..., None],
    gold_mid[None, None, :] * (1 - (gt - 0.5) * 2)[..., None] + gold_bot[None, None, :] * ((gt - 0.5) * 2)[..., None],
)

def circle_alpha(cx, cy, r):
    d = np.hypot(xs - cx, ys - cy)
    return 1 - smoothstep(r - SS, r + SS, d)   # ~1px AA edge

def paint(mask):
    global img
    m = mask[..., None]
    img[:] = img * (1 - m) + gold * m

# ---- crescent: outer disc minus offset disc ----
cx, cy, R = s(512), s(470), s(270)     # outer
ix, iy, r = s(606), s(414), s(238)     # inner (offset up-right -> open crescent)
outer = circle_alpha(cx, cy, R)
inner = circle_alpha(ix, iy, r)
crescent = np.clip(outer - inner, 0, 1)
paint(crescent)

# ---- 8-point star: union of two rounded squares (rounded-rect SDF) ----
def rounded_square_alpha(cx, cy, half, rad, angle_deg):
    a = np.radians(angle_deg)
    dx, dy = xs - cx, ys - cy
    xr = dx * np.cos(a) + dy * np.sin(a)
    yr = -dx * np.sin(a) + dy * np.cos(a)
    qx = np.abs(xr) - (half - rad)
    qy = np.abs(yr) - (half - rad)
    outside = np.hypot(np.maximum(qx, 0), np.maximum(qy, 0))
    inside = np.minimum(np.maximum(qx, qy), 0)
    sdf = outside + inside - rad
    return 1 - smoothstep(-SS, SS, sdf)

scx, scy, sh, sr = s(600), s(412), s(80), s(16)
star = np.maximum(rounded_square_alpha(scx, scy, sh, sr, 45),
                  rounded_square_alpha(scx, scy, sh, sr, -0.0001))
paint(np.clip(star - crescent, 0, 1))   # star sits on top of the crescent

# ---- finalize: downscale for AA, save ----
out = Image.fromarray(np.clip(img, 0, 255).astype('uint8'), 'RGB')
out = out.resize((1024, 1024), Image.LANCZOS)
dest = '/Users/mks/projects/apps/noor-swift/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png'
out.save(dest)
print('saved', dest, out.size, out.mode)
