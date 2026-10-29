"""Luminance along inward lines from a cutout's lower edge, composited on the slate ground (#25292d).
profile.py <cutout.png> : prints the darkest body tone and, for bottom / lower-left / lower-right,
the composited luminance from 8 px outside the stone's opaque edge to 24 px in."""
import sys, numpy as np
from PIL import Image
from scipy import ndimage as ndi
im = np.asarray(Image.open(sys.argv[1]).convert('RGBA')).astype(float)
a = im[..., 3:] / 255
comp = im[..., :3] * a + np.array([0x25, 0x29, 0x2d]) * (1 - a)
L = comp.mean(axis=2)
obj = im[..., 3] > 250
core = ndi.binary_erosion(obj, iterations=25)
print('darkest body (5th pct of core):', round(np.percentile(L[core], 5), 1), ' body median:', round(np.median(L[core]), 1))
cy, cx = np.argwhere(obj).mean(axis=0)
for name, ang in [('top', 270), ('upper-left', 225), ('left', 180), ('lower-left', 135), ('bottom', 90), ('lower-right', 45), ('right', 0)]:
    t = np.deg2rad(ang); d = np.array([np.sin(t), np.cos(t)])    # (dy, dx) outward
    # walk out from the center to the last opaque-ish pixel along this direction
    r = 0
    while True:
        y, x = (np.array([cy, cx]) + (r + 1) * d).round().astype(int)
        if y >= obj.shape[0] or x < 0 or x >= obj.shape[1] or not obj[y, x]: break
        r += 1
    vals = []
    for k in range(-8, 25):
        y, x = (np.array([cy, cx]) + (r - k) * d).round().astype(int)
        vals.append(int(round(L[max(y-1,0):y+2, max(x-1,0):x+2].mean())))
    print(f'{name:12s} outside {vals[:8]} | edge-> {vals[8:]}')
