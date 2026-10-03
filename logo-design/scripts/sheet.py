"""Contact sheet for generated icons, with 16px and 32px legibility tests.

Usage: uv run --with pillow python sheet.py <dir>

Groups files named NN-slug-V.png into one row per NN-slug and writes <dir>/sheet.png.
"""

import glob
import os
import re
import sys

from PIL import Image, ImageDraw, ImageFont

D = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
T, PAD, LH = 300, 24, 40

groups: dict[str, list[tuple[int, str]]] = {}
for p in glob.glob(f"{D}/*.png"):
    m = re.match(r"(\d+-[a-z0-9-]+?)-(\d+)\.png$", os.path.basename(p))
    if m:
        groups.setdefault(m.group(1), []).append((int(m.group(2)), p))
if not groups:
    sys.exit(f"no NN-slug-V.png files in {D}")

cols = max(len(v) for v in groups.values())
cell = T + 16 + 64 + 16 + 64 + PAD
W = PAD + cols * cell
H = PAD + len(groups) * (T + LH + PAD)
sheet = Image.new("RGB", (W, H), (232, 232, 228))
draw = ImageDraw.Draw(sheet)
try:
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 22)
except OSError:
    font = ImageFont.load_default()

y = PAD
for key in sorted(groups):
    x = PAD
    for v, p in sorted(groups[key]):
        im = Image.open(p).convert("RGB")
        sheet.paste(im.resize((T, T), Image.LANCZOS), (x, y + LH))
        cx = x + T + 16
        for s, zoom in ((16, 4), (32, 2)):
            small = im.resize((s, s), Image.LANCZOS)
            sheet.paste(small, (cx, y + LH))  # true size
            sheet.paste(small.resize((s * zoom, s * zoom), Image.NEAREST), (cx, y + LH + 40))  # pixels enlarged
            cx += 64 + 16
        draw.text((x, y + 8), f"{key} · v{v}", fill=(20, 20, 20), font=font)
        x += cell
    y += T + LH + PAD

out = f"{D}/sheet.png"
sheet.save(out)
print(out, sheet.size)
