"""Regenerate the two lava animation strips. Requires Pillow."""

from math import cos, sin, tau
from pathlib import Path

from PIL import Image


TEXTURES = Path(__file__).resolve().parents[1] / "pack/assets/minecraft/textures/block"
FRAMES = 16

# A thin amber film, with the highest opacity reserved for the hot ripples.
PALETTE = (
    (220, 68, 13, 30),
    (241, 87, 15, 37),
    (253, 111, 20, 46),
    (255, 149, 36, 69),
    (255, 193, 70, 92),
)


def still_ripple(x, y, phase):
    bend = 0.65 * sin(y + phase)
    return sin(x + bend) + 0.65 * cos(2 * y - x - phase) + 0.4 * sin(y + x + phase)


def flowing_ripple(x, y, phase):
    # The pattern travels down the sprite and wraps at both the tile and loop edges.
    down = y - phase
    return sin(2 * x + 0.8 * sin(down)) + 0.65 * cos(x - down) + 0.4 * sin(2 * down + x)


def write_strip(name, size, ripple):
    sheet = Image.new("RGBA", (size, size * FRAMES))
    pixels = []
    for frame in range(FRAMES):
        phase = tau * frame / FRAMES
        for y in range(size):
            for x in range(size):
                # Flowing lava samples subregions of a double-width (32 px) sprite.
                value = ripple(tau * (x % 16) / 16, tau * (y % 16) / 16, phase)
                band = sum(value > cut for cut in (-0.8, 0.1, 0.95, 1.45))
                pixels.append(PALETTE[band])
    sheet.putdata(pixels)
    sheet.save(TEXTURES / f"{name}.png", optimize=True)


if __name__ == "__main__":
    write_strip("lava_still", 16, still_ripple)
    write_strip("lava_flow", 32, flowing_ripple)
