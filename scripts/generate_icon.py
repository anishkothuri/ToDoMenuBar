#!/usr/bin/env python3
"""Generates the TodoMenuBar app icon at every size macOS needs."""
import os
from PIL import Image, ImageDraw

SIZE = 1024
OUT_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "TodoMenuBar", "Assets.xcassets", "AppIcon.appiconset",
)


def rounded_rect_mask(size, radius):
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, size - 1, size - 1], radius=radius, fill=255)
    return mask


def make_base_icon():
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))

    pad = int(SIZE * 0.085)
    shape_size = SIZE - pad * 2
    radius = int(shape_size * 0.225)

    grad = Image.new("RGBA", (shape_size, shape_size), (0, 0, 0, 0))
    top = (99, 102, 241)     # indigo #6366F1
    bottom = (16, 185, 129)  # emerald #10B981
    for y in range(shape_size):
        t = y / (shape_size - 1)
        r = int(top[0] + (bottom[0] - top[0]) * t)
        g = int(top[1] + (bottom[1] - top[1]) * t)
        b = int(top[2] + (bottom[2] - top[2]) * t)
        ImageDraw.Draw(grad).line([(0, y), (shape_size, y)], fill=(r, g, b, 255))

    mask = rounded_rect_mask(shape_size, radius)
    canvas.paste(grad, (pad, pad), mask)

    gloss = Image.new("RGBA", (shape_size, shape_size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gloss)
    gd.rounded_rectangle([0, 0, shape_size - 1, int(shape_size * 0.55)], radius=radius, fill=(255, 255, 255, 26))
    gloss_mask = rounded_rect_mask(shape_size, radius)
    composited = Image.alpha_composite(canvas.crop((pad, pad, pad + shape_size, pad + shape_size)), gloss)
    canvas.paste(composited, (pad, pad), gloss_mask)

    draw = ImageDraw.Draw(canvas)
    stroke_w = int(shape_size * 0.09)
    cx, cy = SIZE / 2, SIZE / 2
    scale = shape_size * 0.5
    p1 = (cx - scale * 0.42, cy + scale * 0.02)
    p2 = (cx - scale * 0.10, cy + scale * 0.34)
    p3 = (cx + scale * 0.46, cy - scale * 0.32)

    draw.line([p1, p2], fill=(255, 255, 255, 255), width=stroke_w, joint="curve")
    draw.line([p2, p3], fill=(255, 255, 255, 255), width=stroke_w, joint="curve")
    for pt in (p1, p2, p3):
        r = stroke_w / 2
        draw.ellipse([pt[0] - r, pt[1] - r, pt[0] + r, pt[1] + r], fill=(255, 255, 255, 255))

    return canvas


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    base = make_base_icon()

    sizes = {
        "icon_16x16.png": 16,
        "icon_16x16@2x.png": 32,
        "icon_32x32.png": 32,
        "icon_32x32@2x.png": 64,
        "icon_128x128.png": 128,
        "icon_128x128@2x.png": 256,
        "icon_256x256.png": 256,
        "icon_256x256@2x.png": 512,
        "icon_512x512.png": 512,
        "icon_512x512@2x.png": 1024,
    }

    for name, px in sizes.items():
        base.resize((px, px), Image.LANCZOS).save(os.path.join(OUT_DIR, name))

    print(f"Wrote {len(sizes)} icon files to {OUT_DIR}")


if __name__ == "__main__":
    main()
