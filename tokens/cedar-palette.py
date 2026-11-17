"""The Cedar palette: woody, apothecary colours (linen, oak, sage, smoke, clay, fig, honey).

Each step of each family has exactly the relative luminance of the step it replaced in the Heritage Luxury palette
that Cedar replaced in 0.7.0 (parchment, brass, forest, slate, bordeaux), so every contrast ratio the audit checked stays the same; only hue and
chroma change. Run from the repo root: `python3 tokens/cedar-palette.py` prints the hex values as JSON.

Hue is an OKLCH hue in degrees; chroma rises towards the middle of the scale and falls at both ends, so the lightest
and darkest steps stay calm.
"""
import json
import math

STEPS = [100, 200, 300, 400, 500, 600, 700, 800, 900]

# The luminance ladders the families keep: the Heritage Luxury primitives Cedar replaced.
SOURCE = {
    'parchment': ['fbf7ef', 'f1e8d8', 'e2d0b3', 'c3ac88', '9a7e5a', '72593e', '503b28', '322319', '1c140f'],
    'brass': ['fbf4e3', 'f2e1b7', 'ddbf7c', 'c4a05b', 'aa8240', '8b6832', '6e512a', '49351d', '2f2213'],
    'bordeaux': ['f9eef0', 'ecd5d9', 'd4a6b0', 'b97b8a', 'a2596c', '8c4050', '692c35', '481b26', '2c1019'],
    'forest': ['eff4e9', 'd9e4cb', 'b9caa4', '94ac7f', '718a60', '4e6848', '294432', '1b2d23', '101d17'],
    'slate': ['eef3f1', 'd8e3df', 'b4cbc4', '8daca6', '668d86', '456b65', '2d4549', '1e3034', '111d20'],
}

# name: (luminance ladder, OKLCH hue, peak chroma)
FAMILIES = {
    'linen': ('parchment', 72, 0.022),   # sand, stone, warm grey-brown
    'oak': ('brass', 70, 0.054),         # light oak to walnut
    'honey': ('brass', 74, 0.115),       # amber glass
    'sage': ('forest', 118, 0.050),      # olive sage
    'smoke': ('slate', 235, 0.030),      # warm blue-grey
    'clay': ('bordeaux', 38, 0.105),     # terracotta to rust
    'fig': ('bordeaux', 355, 0.070),     # muted plum
}


def srgb_to_linear(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def linear_to_srgb(c):
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055


def luminance_hex(h):
    r, g, b = (srgb_to_linear(int(h[i:i + 2], 16) / 255) for i in (0, 2, 4))
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def oklch_to_linear_rgb(L, C, hdeg):
    a, b = C * math.cos(math.radians(hdeg)), C * math.sin(math.radians(hdeg))
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    return (4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
            -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
            -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s)


def in_gamut(rgb):
    return all(-1e-6 <= c <= 1 + 1e-6 for c in rgb)


def to_hex(rgb):
    return ''.join(f'{round(max(0, min(1, linear_to_srgb(max(0.0, c)))) * 255):02x}' for c in rgb)


def colour(target_y, hue, chroma):
    """The OKLCH colour with this hue whose luminance is target_y, at the largest chroma up to `chroma` in gamut."""
    best = None
    for k in range(40):
        c = chroma * (1 - k / 40)
        lo, hi = 0.0, 1.0
        for _ in range(60):
            mid = (lo + hi) / 2
            r, g, b = oklch_to_linear_rgb(mid, c, hue)
            y = 0.2126 * r + 0.7152 * g + 0.0722 * b
            lo, hi = (mid, hi) if y < target_y else (lo, mid)
        rgb = oklch_to_linear_rgb(lo, c, hue)
        if in_gamut(rgb):
            best = rgb
            break
    return to_hex(best)


def palette():
    out = {}
    for name, (ladder, hue, peak) in FAMILIES.items():
        for i, step in enumerate(STEPS):
            # Chroma curve: 30% at the ends, full in the middle.
            t = abs(i - 4) / 4
            c = peak * (1 - 0.7 * t ** 1.6)
            target = luminance_hex(SOURCE[ladder][i])
            out[f'color/cedar/{name}/{step}'] = colour(target, hue, c)
    return out


if __name__ == '__main__':
    print(json.dumps(palette(), indent=2))
