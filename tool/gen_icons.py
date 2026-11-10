#!/usr/bin/env python3
"""Draws the PandaBudget launcher icons (Android mipmaps, Windows .ico).

The shapes mirror lib/app/panda_logo.dart. Needs Pillow.
Run from the repository root:  python3 tool/gen_icons.py
"""
import math

from PIL import Image, ImageDraw

BAMBOO = (90, 138, 43, 255)
INK = (21, 23, 22, 255)
WHITE = (255, 255, 255, 255)


def ellipse(draw, cx, cy, w, h, fill):
    draw.ellipse([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], fill=fill)


def rotated_ellipse(image, cx, cy, w, h, angle, fill):
    size = int(max(w, h) * 2)
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ellipse(ImageDraw.Draw(layer), size / 2, size / 2, w, h, fill)
    layer = layer.rotate(-math.degrees(angle), resample=Image.BICUBIC)
    image.alpha_composite(layer, (int(cx - size / 2), int(cy - size / 2)))


def panda(size, round_background=True):
    # Draw large and scale down for smooth edges.
    s = 1024
    image = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    if round_background:
        ellipse(draw, s / 2, s / 2, s, s, BAMBOO)
    else:
        draw.rectangle([0, 0, s, s], fill=BAMBOO)
    ellipse(draw, s * 0.27, s * 0.28, s * 0.24, s * 0.24, INK)
    ellipse(draw, s * 0.73, s * 0.28, s * 0.24, s * 0.24, INK)
    ellipse(draw, s / 2, s * 0.55, s * 0.64, s * 0.56, WHITE)
    for side in (-1, 1):
        rotated_ellipse(
            image, s / 2 + side * s * 0.14, s * 0.52, s * 0.13, s * 0.18, side * 0.5, INK
        )
        ellipse(
            ImageDraw.Draw(image),
            s / 2 + side * s * 0.135,
            s * 0.51,
            s * 0.044,
            s * 0.044,
            WHITE,
        )
    ellipse(ImageDraw.Draw(image), s / 2, s * 0.665, s * 0.09, s * 0.06, INK)
    return image.resize((size, size), Image.LANCZOS)


for density, size in {
    "mdpi": 48,
    "hdpi": 72,
    "xhdpi": 96,
    "xxhdpi": 144,
    "xxxhdpi": 192,
}.items():
    panda(size).save(f"android/app/src/main/res/mipmap-{density}/ic_launcher.png")

panda(256).save(
    "windows/runner/resources/app_icon.ico",
    sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
)
print("icons written")
