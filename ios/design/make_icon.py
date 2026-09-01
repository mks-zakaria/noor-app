import numpy as np
from PIL import Image

SS = 2                      # supersample factor
W = 1024 * SS
def s(v): return v * SS     # logical(1024) -> render coords

def hex2rgb(h):
    h = h.lstrip('#')
    return np.array([int(h[i:i+2], 16) for i in (0, 2, 4)], dtype=float)

# coordinate grids
ys, xs = np.mgrid[0:W, 0:W].astype(float)

# ---- background: diagonal emerald gradient ----
c0, c1 = hex2rgb('#0F8A6B'), hex2rgb('#083A2C')
t = (xs + ys) / (2 * W)
img = c0[None, None, :] * (1 - t)[..., None] + c1[None, None, :] * t[..., None]

def smoothstep(edge0, edge1, x):
    tt = np.clip((x - edge0) / (edge1 - edge0), 0, 1)
    return tt * tt * (3 - 2 * tt)

# ---- gold "noor" glow ----
gcx, gcy, gr = s(512), s(470), s(470)
dist = np.hypot(xs - gcx, ys - gcy)
glow_a = (1 - smoothstep(0, gr, dist)) * 0.45
glow_col = hex2rgb('#F6E7B8')
img = img * (1 - glow_a[..., None]) + glow_col[None, None, :] * glow_a[..., None]

# ---- vertical gold gradient (fill for shapes) ----
gt = np.clip(ys / W, 0, 1)
gold_top, gold_mid, gold_bot = hex2rgb('#F4D77E'), hex2rgb('#E8C15A'), hex2rgb('#C99A3B')
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
outer = circle_alpha(s(470), s(540), s(286))
inner = circle_alpha(s(566), s(502), s(256))
crescent = np.clip(outer - inner, 0, 1)
paint(crescent)

# ---- 8-point star: two rounded squares (rounded-rect SDF) ----
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

scx, scy, sh, sr = s(640), s(468), s(85), s(16)
star = np.maximum(rounded_square_alpha(scx, scy, sh, sr, 0),
                  rounded_square_alpha(scx, scy, sh, sr, 45))
paint(star)

# emerald center dot
dot = circle_alpha(scx, scy, s(28))
emerald = hex2rgb('#0E7A5F')
img[:] = img * (1 - dot[..., None]) + emerald[None, None, :] * dot[..., None]

# ---- finalize: downscale for AA, save opaque RGB ----
out = Image.fromarray(np.clip(img, 0, 255).astype('uint8'), 'RGB')
out = out.resize((1024, 1024), Image.LANCZOS)
dest = '/Users/mks/Desktop/noor-swift/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png'
out.save(dest)
print('saved', dest, out.size, out.mode)
