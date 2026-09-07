"""Regenerate film-frame-1512x2016.png, the overlay mask for pad.sh's film layout.

A 3:4 RGBA image, opaque black everywhere except a transparent rounded
rectangle inset by the border width, with a softly feathered edge.
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

W, H = 1512, 2016
border = 34
radius = 64
feather = 2.5


def main():
    m = Image.new("L", (W, H), 0)
    ImageDraw.Draw(m).rounded_rectangle((border, border, W - border, H - border), radius=radius, fill=255)
    m = m.filter(ImageFilter.GaussianBlur(feather))
    frame = Image.new("RGBA", (W, H), (0, 0, 0, 255))
    frame.putalpha(Image.eval(m, lambda v: 255 - v))
    out = Path(__file__).resolve().parent / f"film-frame-{W}x{H}.png"
    frame.save(out)
    print(out)


if __name__ == "__main__":
    main()
