"""Step 1: cut each whole object out of the photo into its own lossless file, with margin for its shadow,
and a sidecar .json with the object's box inside the crop and any per-object overrides. Objects touching
the photo's edge are left out (they're cut off), and so is the grey stone, whose body is too close in
value to its own shadow to separate cleanly."""
import sys, json, numpy as np
from PIL import Image
src, outdir = sys.argv[1], sys.argv[2]
im = Image.open(src).convert('RGB')
# (name, kind, x0, y0, x1, y1): the object's own extent in the photo
OBJECTS = [
    ('stone-dark-flat',     'dark', 1240,   88, 1675,  425, {'T': 95}),   # its contact shadow starts near 110
    ('inkwell-black-a',     'dark', 1828,  484, 2248,  938),
    ('inkwell-brown-a',     'dark',  196,  517,  640, 1003),
    ('inkwell-brown-b',     'dark',  729,  523, 1145,  968),
    ('stone-dark-oval',     'dark', 1241,  549, 1727,  889),
    ('inkwell-black-b',     'dark', 1828,  983, 2241, 1442),
    ('stone-dark-egg',      'dark', 1259, 1020, 1700, 1374),
    ('stone-dark-round',    'dark',  221, 1065,  578, 1499),
    ('stone-pale-round',    'pale',  737, 1000, 1097, 1440),
    ('stone-pale',          'pale', 2345,  930, 2664, 1343),
]
# every object body in the photo, including ones not cut out (edge-clipped, the grey stone), so each
# cutout's shadow can stop short of its neighbors: a shadow reaches at most 60% of the gap, 55 px at most
ALL = [o[2:6] for o in OBJECTS] + [(773, 0, 1085, 452), (1813, 0, 2259, 422), (233, 127, 625, 449),
                                   (1308, 1480, 1622, 1536), (1893, 1494, 2203, 1536)]
def reach(x0, y0, x1, y1):
    gaps = {'up': 999, 'down': 999, 'left': 999, 'right': 999}
    for nx0, ny0, nx1, ny1 in ALL:
        if (nx0, ny0, nx1, ny1) == (x0, y0, x1, y1): continue
        if nx0 < x1 and nx1 > x0:                      # overlaps horizontally: above or below
            if ny0 >= y1: gaps['down'] = min(gaps['down'], ny0 - y1)
            if ny1 <= y0: gaps['up'] = min(gaps['up'], y0 - ny1)
        if ny0 < y1 and ny1 > y0:                      # overlaps vertically: left or right
            if nx0 >= x1: gaps['right'] = min(gaps['right'], nx0 - x1)
            if nx1 <= x0: gaps['left'] = min(gaps['left'], x0 - nx1)
    return {k: float(np.clip(0.6 * g, 10, 55)) for k, g in gaps.items()}
M = 110
for name, kind, x0, y0, x1, y1, *opt in OBJECTS:
    box = (max(x0 - M, 0), max(y0 - M, 0), min(x1 + M, im.width), min(y1 + M, im.height))
    im.crop(box).save(f'{outdir}/{kind}--{name}.png')
    # the object's own box inside the crop (margins differ where the photo's edge is near), plus overrides
    meta = {'box': [x0 - box[0], y0 - box[1], x1 - box[0], y1 - box[1]], 'reach': reach(x0, y0, x1, y1),
            **(opt[0] if opt else {})}
    json.dump(meta, open(f'{outdir}/{kind}--{name}.json', 'w'))
    print(name, kind, box, meta)
