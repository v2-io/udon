"""Step 2: cut one object out of its own crop (from split.py), keeping its shadow.

  cutone.py <crop.png> <out.png> [inset=3]

The crop's sidecar .json gives the object's box inside the crop and any overrides (T: the dark cut; cut: 'below' to apply it only below the object's middle).

The crop's kind (dark/pale) is in its filename. Everything is measured inside this one crop:
  - the paper level is fitted to the crop's own border;
  - the object is the one at the crop's center (neighbors poking into the margin are ignored);
  - a hard mask of it: its silhouette traced, smoothed, set `inset` px inside the photo's blended rim;
  - the background just outside is clamped (rim leftovers replaced by the paper beyond), then made
    transparent by its white level, so shadows stay as black at partial alpha and fade before neighbors;
  - dark objects get a soft inset shadow along the inner edge.
"""
import sys, os, json, numpy as np, cv2
from PIL import Image
from scipy import ndimage as ndi
src, dst = sys.argv[1], sys.argv[2]
INSET = float(sys.argv[3]) if len(sys.argv) > 3 else 2.0
meta = json.load(open(os.path.splitext(src)[0] + '.json'))
bx0, by0, bx1, by1 = meta['box']
kind = os.path.basename(src).split('--')[0]
P = np.asarray(Image.open(src).convert('RGB')).astype(np.float64)
h, w, _ = P.shape
L = P.mean(axis=2)

# paper level from this crop's border (brightest part of it, so neighbors and shadows don't count)
bd = np.zeros((h, w), bool); bd[:6] = bd[-6:] = True; bd[:, :6] = bd[:, -6:] = True
pick = bd & (L > np.percentile(L[bd], 50))
yy, xx = np.mgrid[0:h, 0:w]
Abd = np.stack([np.ones(pick.sum()), xx[pick] / w, yy[pick] / h], -1)
plate = np.stack([(np.stack([np.ones_like(xx), xx / w, yy / h], -1).reshape(-1, 3)
                   @ np.linalg.lstsq(Abd, P[pick][:, c], rcond=None)[0]).reshape(h, w) for c in range(3)], -1)
Ln = np.clip(P / plate * 255.0, 0, 255).mean(axis=2)

def at_center(mask):   # the object's component (by its box center), ignoring neighbors in the margin
    lab, n = ndi.label(mask)
    if n == 0: return mask
    oy, ox = (by0 + by1) // 2, (bx0 + bx1) // 2
    c = lab[oy, ox]
    if c == 0:   # center not inside: take the component nearest the center
        d = ndi.distance_transform_edt(lab == 0, return_indices=True)[1]
        c = lab[d[0][oy, ox], d[1][oy, ox]]
    return lab == c

# --- segmentation, by kind
init = np.full((h, w), cv2.GC_BGD, np.uint8)
g = 30 if kind == 'dark' else 12
init[max(by0 - g, 0):by1 + g, max(bx0 - g, 0):bx1 + g] = cv2.GC_PR_FGD
if kind == 'dark':
    init[ndi.binary_erosion(ndi.binary_fill_holes(at_center(Ln < 120)), iterations=12)] = cv2.GC_FGD
else:
    cy, cx = (by0 + by1) / 2, (bx0 + bx1) / 2; ay, ax = (by1 - by0) / 2 * 0.78, (bx1 - bx0) / 2 * 0.78
    init[((yy - cy) / ay) ** 2 + ((xx - cx) / ax) ** 2 <= 1] = cv2.GC_FGD
init[Ln > 249] = cv2.GC_BGD
bgd, fgd = np.zeros((1, 65)), np.zeros((1, 65))
cv2.grabCut(cv2.cvtColor(P.astype(np.uint8), cv2.COLOR_RGB2BGR), init, None, bgd, fgd, 8, cv2.GC_INIT_WITH_MASK)
M = ndi.binary_fill_holes(ndi.binary_opening(at_center((init == cv2.GC_FGD) | (init == cv2.GC_PR_FGD)), iterations=2))
note = ''
inkwell = False
if kind == 'dark':
    # Under a stone the contact shadow starts dark (~110 against the paper) and fades out, while the
    # stone's edge stays near its body value: cut by the stone's own core. Inkwells (near-black ink,
    # lit ceramic walls) keep a looser cut.
    core = ndi.binary_erosion(M, iterations=15)
    inkwell = (Ln[core] < 30).mean() > 0.3
    T = meta.get('T', 175 if inkwell else min(175, np.median(Ln[core]) + 50))
    keep = ndi.binary_opening(Ln < T, iterations=1)
    if not inkwell:   # the light is above: shadows fall below, while a stone's top is lit and meets clean paper
        keep[:(by0 + by1) // 2] = True
    M = ndi.binary_fill_holes(at_center(M & keep))
    note = f'{"inkwell" if inkwell else "stone"} T={T:.0f}'

# --- hard mask of the physical object: its convex hull (pebbles and inkwells are convex from above),
# traced smooth and set INSET px inside the photo's blended rim. Supersampling gives each edge pixel
# its true coverage; nothing is blurred.
cs, _ = cv2.findContours(M.astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
hull = cv2.convexHull(max(cs, key=cv2.contourArea))[:, 0, :].astype(np.float64)
seg = np.vstack([hull, hull[:1]]); d = np.hypot(*np.diff(seg, axis=0).T)
t = np.concatenate([[0], np.cumsum(d)]); u = np.arange(0, t[-1], 1.0)
pts = np.stack([np.interp(u, t, seg[:, 0]), np.interp(u, t, seg[:, 1])], -1)
pts = np.stack([ndi.gaussian_filter1d(pts[:, i], 3.0, mode='wrap') for i in range(2)], -1)
if kind == 'dark' and inkwell:
    # inkwells are round from above: fit an ellipse to the traced outline, drop the points that stray
    # outward (shadow that crept into the mask), refit, and use the ellipse itself as the silhouette
    raw = max(cs, key=cv2.contourArea)[:, 0, :].astype(np.float32)
    for _ in range(3):
        (ex, ey), (ea, eb), ang = cv2.fitEllipse(raw)
        th = np.deg2rad(ang); ct, st = np.cos(th), np.sin(th)
        qx, qy = raw[:, 0] - ex, raw[:, 1] - ey
        rr = np.hypot((qx * ct + qy * st) / (ea / 2), (-qx * st + qy * ct) / (eb / 2))
        raw = raw[rr <= np.percentile(rr, 85) * 1.0 + 0.02] if rr.max() > 1.03 else raw
    (ex, ey), (ea, eb), ang = cv2.fitEllipse(raw)
    th = np.deg2rad(ang); tt = np.linspace(0, 2 * np.pi, 2000, endpoint=False)
    px, py = ea / 2 * np.cos(tt), eb / 2 * np.sin(tt)
    pts = np.stack([ex + px * np.cos(th) - py * np.sin(th), ey + px * np.sin(th) + py * np.cos(th)], -1)
    note += f' ellipse {ea:.0f}x{eb:.0f}'
SS = 4
big = np.zeros((h * SS, w * SS), np.uint8)
cv2.fillPoly(big, [np.round((pts + 0.5) * SS - 0.5).astype(np.int32)], 1)
inside = ndi.distance_transform_edt(big) > INSET * SS
a = inside.reshape(h, SS, w, SS).mean(axis=(1, 3))
Mh = a > 0.5

# --- background: clamp the rim's leftovers (the 0-6 px just outside the mask, where object and paper
# blend), replacing them with the paper or shadow just beyond; then the background's alpha is its
# darkness against the white level, as black. Near-white clamps to fully transparent.
rim = ndi.binary_dilation(Mh, iterations=6)
ring = ndi.binary_dilation(Mh, iterations=12) & ~rim
_, (ry, rx) = ndi.distance_transform_edt(~ring, return_indices=True)
Lbg = np.where(rim, Ln[ry, rx], Ln)
WHITE = 245.0
s = np.clip(1 - Lbg / WHITE, 0, 1)
# this object's shadow only: it fades out before reaching any neighbor (reach per side, from split.py)
dist, (ny, nx) = ndi.distance_transform_edt(~Mh, return_indices=True)
dy, dx = yy - ny, xx - nx
rv = np.where(dy > 0, meta['reach']['down'], meta['reach']['up'])
rh = np.where(dx > 0, meta['reach']['right'], meta['reach']['left'])
wv = dy * dy / np.maximum(dy * dy + dx * dx, 1e-9)          # blend by direction, so no seam on diagonals
R = wv * rv + (1 - wv) * rh
f = np.clip(1 - dist / R, 0, 1); s *= f * f * (3 - 2 * f)          # smoothstep fade

# --- the object: its own pixels
C = P.copy()
stone = kind == 'dark' and not inkwell
if stone:
    # One edge model all round the outline. The photo's white paper lit the stones' rims: from the side
    # and above as a glow, and from below as bounce light, which a stone lit from above can't have.
    #  - All round, the edge starts at EDGE x the stone's local body tone (its surface faces sideways
    #    there, away from the light above) and eases up to that body tone BAND px in.
    #  - Underneath, that tone blends (smoothly with angle) into the underside's median darkness, and only
    #    the outermost pixel or two dip to the darkest the underside gets.
    # Every correction multiplies the existing pixels by a smoothly varying factor, so the grain stays.
    BAND, EDGE = 16.0, 0.6
    dvis = ndi.distance_transform_edt(big).reshape(h, SS, w, SS).mean(axis=(1, 3)) / SS - INSET
    gy, gx = np.gradient(ndi.gaussian_filter(dvis, 2.0))
    gn = np.maximum(np.hypot(gx, gy), 1e-6)
    nyv, nxv = -gy / gn, -gx / gn                                       # outward normal, +down
    lum = C.mean(axis=2)
    lsm = ndi.gaussian_filter(lum, 2.0)                                  # local average (keeps grain out)
    local = ndi.map_coordinates(ndi.gaussian_filter(ndi.percentile_filter(lum, 50, size=15), 2.0),
                                [yy - nyv * (BAND + 6), xx - nxv * (BAND + 6)], order=1, mode='nearest')
    wb = np.clip((nyv + 0.45) / 0.9, 0, 1); wb = wb * wb * (3 - 2 * wb)  # bottomness, wide and smooth
    under = (wb > 0.6) & (dvis > 6) & (dvis < 30)
    under_tone = np.median(lum[under])                                   # the underside's typical darkness
    dark_tone = np.percentile(lum[under], 10)                            # the darkest it gets
    side = EDGE * local                    # a pebble darkens toward its silhouette, where it faces sideways
    below = np.maximum(np.minimum(local, under_tone), dark_tone)          # underneath: the underside's tone
    edge = side + wb * (below - side)                                    # tone at the edge, by angle
    rim = np.clip(1 - np.maximum(dvis, 0) / 1.5, 0, 1)                   # the outermost pixel or two
    edge = edge + wb * rim * (np.minimum(edge, dark_tone) - edge)
    ramp = np.clip(dvis / BAND, 0, 1); ramp = ramp * ramp * (3 - 2 * ramp)
    target = edge + (local - edge) * ramp
    near = (a > 0.001) & (dvis < BAND)
    ceiling = target
    floor = 0.9 * target * wb                                            # underneath, not much darker either
    fixed = np.clip(lsm, floor, ceiling)
    C *= np.where(near, fixed / np.maximum(lsm, 1e-3), 1.0)[..., None]
    note += f' under {under_tone:.0f} darkest {dark_tone:.0f}'

if kind == 'dark' and not stone:
    # inkwells: an inset shadow along the inner edge (up to 5 px deep), which also swallows the
    # photo's white rim light
    din = ndi.distance_transform_edt(big).reshape(h, SS, w, SS).mean(axis=(1, 3)) / SS - INSET
    g = np.clip(1 - din / 5.0, 0, 1) ** 1.6
    C *= (1 - 0.6 * g)[..., None]

if stone:
    # last: a soft drop shadow under the stone, merged with the photo's own shadow, so it sits on the
    # ground rather than hovering
    drop = ndi.gaussian_filter(ndi.shift(a, (5, 1), order=1), 6.0) * 0.38
    s = 1 - (1 - s) * (1 - drop)

A = a + (1 - a) * s
rgb = np.where(A[..., None] > 1e-4, (a[..., None] * C) / np.maximum(A, 1e-4)[..., None], 0)
out = np.dstack([rgb, A * 255]).clip(0, 255).astype(np.uint8)
ys, xs = np.where(out[..., 3] > 2)
out = out[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
Image.fromarray(out, 'RGBA').save(dst, optimize=True)
print(os.path.basename(dst), kind, note, 'reach', {k: round(v) for k, v in meta['reach'].items()}, f'{out.shape[1]}x{out.shape[0]}')
