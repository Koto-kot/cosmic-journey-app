#!/usr/bin/env python3
"""Paint the live-screen Earth as favicon and PWA icons."""

from __future__ import annotations

import math
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "app" / "web"
ICONS = WEB / "icons"

ACCENT = (0x4F, 0xAC, 0xFE, 255)
BG = (0, 0, 0, 255)


def _png(width: int, height: int, pixels: list[tuple[int, int, int, int]]) -> bytes:
    raw = bytearray()
    for y in range(height):
        raw.append(0)
        for x in range(width):
            raw.extend(pixels[y * width + x])

    def chunk(tag: bytes, data: bytes) -> bytes:
        crc = zlib.crc32(tag + data) & 0xFFFFFFFF
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", crc)

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + chunk(b"IEND", b"")
    )


def _lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t


def _mix(
    c0: tuple[int, int, int, int], c1: tuple[int, int, int, int], t: float
) -> tuple[int, int, int, int]:
    t = max(0.0, min(1.0, t))
    return (
        int(_lerp(c0[0], c1[0], t)),
        int(_lerp(c0[1], c1[1], t)),
        int(_lerp(c0[2], c1[2], t)),
        int(_lerp(c0[3], c1[3], t)),
    )


def _globe_color(nx: float, ny: float) -> tuple[int, int, int, int]:
    light = math.hypot(nx + 0.55, ny + 0.1)
    if light < 0.38:
        t = light / 0.38
        return _mix((0x7E, 0xC8, 0xFF, 255), (0x16, 0x3A, 0x66, 255), t)
    if light < 0.72:
        t = (light - 0.38) / 0.34
        return _mix((0x16, 0x3A, 0x66, 255), (0x07, 0x0B, 0x12, 255), t)
    t = min(1.0, (light - 0.72) / 0.28)
    return _mix((0x07, 0x0B, 0x12, 255), (0x02, 0x03, 0x08, 255), t)


def _in_continent(nx: float, ny: float) -> bool:
    blob1 = ((nx + 0.15) / 0.35) ** 2 + ((ny + 0.05) / 0.475) ** 2
    blob2 = ((nx - 0.28) / 0.21) ** 2 + ((ny - 0.22) / 0.14) ** 2
    return blob1 <= 1.0 or blob2 <= 1.0


def _ring_alpha(px: float, py: float, cx: float, cy: float, size: int) -> float:
    # Match EarthFallbackPainter: rotate -0.52 rad, scale Y by 0.36.
    dx = px - cx
    dy = py - cy
    ang = 0.52
    rx = dx * math.cos(ang) - dy * math.sin(ang)
    ry = (dx * math.sin(ang) + dy * math.cos(ang)) / 0.36
    ring_r = size * 0.26 * 1.48
    dist = math.hypot(rx, ry)
    band = abs(dist - ring_r)
    width = max(1.2, size * 0.012)
    if band > width * 2:
        return 0.0
    sweep = (math.atan2(ry, rx) + math.pi) / (2 * math.pi)
    glow = 0.0
    if 0.28 <= sweep <= 0.62:
        glow = 0.55 * (1.0 - abs(sweep - 0.48) / 0.2)
    return max(0.0, glow * (1.0 - band / (width * 2)))


def paint_earth(size: int, *, maskable: bool = False) -> bytes:
    pixels: list[tuple[int, int, int, int]] = []
    cx = cy = (size - 1) / 2
    pad = 0.18 if maskable else 0.0
    usable = size * (1.0 - 2 * pad)
    radius = usable * (0.30 if maskable else 0.26)
    if size <= 48 and not maskable:
        radius = size * 0.34
    for y in range(size):
        for x in range(size):
            color = BG
            px, py = float(x), float(y)
            dx, dy = px - cx, py - cy
            dist = math.hypot(dx, dy)

            glow_cx = cx - radius * 0.32
            glow_dist = math.hypot(px - glow_cx, py - cy)
            if glow_dist < radius * 1.35:
                g = max(0.0, 1.0 - glow_dist / (radius * 1.35))
                color = _mix(color, ACCENT, 0.16 * g * g)

            ring_a = _ring_alpha(px, py, cx, cy, size)
            if ring_a > 0:
                color = _mix(color, ACCENT, ring_a)

            if dist <= radius:
                nx, ny = dx / radius, dy / radius
                color = _globe_color(nx, ny)
                night = math.hypot(nx - 0.55, ny - 0.1)
                if night < 0.85:
                    night_t = (night / 0.85) ** 2
                    color = _mix((0x02, 0x03, 0x08, 210), color, night_t)
                if _in_continent(nx, ny):
                    color = _mix(color, (0x1A, 0x2A, 0x22, 255), 0.55)
                if dist > radius * 0.86:
                    color = _mix(
                        color, ACCENT, 0.35 * ((dist / radius) - 0.86) / 0.14
                    )
            elif dist <= radius + max(1.2, size * 0.02):
                color = _mix(color, ACCENT, 0.45)
            pixels.append(color)

    lights = _SplitMix(42)
    for _ in range(max(12, size // 4)):
        ang = lights.next() * math.pi * 2
        dist = lights.next() * radius * 0.82
        lx = int(cx + math.cos(ang) * dist)
        ly = int(cy + math.sin(ang) * dist)
        if 0 <= lx < size and 0 <= ly < size:
            idx = ly * size + lx
            alpha = 0.15 + lights.next() * 0.55
            pixels[idx] = _mix(pixels[idx], (255, 220, 140, 255), alpha)

    return _png(size, size, pixels)


class _SplitMix:
    def __init__(self, seed: int) -> None:
        self.state = seed & 0xFFFFFFFF

    def next(self) -> float:
        self.state = (self.state + 0x9E3779B9) & 0xFFFFFFFF
        z = self.state
        z = ((z ^ (z >> 16)) * 0x85EBCA6B) & 0xFFFFFFFF
        z = ((z ^ (z >> 13)) * 0xC2B2AE35) & 0xFFFFFFFF
        z = (z ^ (z >> 16)) & 0xFFFFFFFF
        return z / 0xFFFFFFFF


def write(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    print(f"wrote {path} ({len(data)} bytes)")


SVG = """\
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <rect width="64" height="64" fill="#000"/>
  <defs>
    <radialGradient id="glow" cx="28%" cy="50%" r="55%">
      <stop offset="0%" stop-color="#4FACFE" stop-opacity="0.28"/>
      <stop offset="100%" stop-color="#4FACFE" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="globe" cx="32%" cy="46%" r="70%">
      <stop offset="0%" stop-color="#7EC8FF"/>
      <stop offset="38%" stop-color="#163A66"/>
      <stop offset="72%" stop-color="#070B12"/>
      <stop offset="100%" stop-color="#020308"/>
    </radialGradient>
    <radialGradient id="night" cx="72%" cy="54%" r="62%">
      <stop offset="0%" stop-color="#020308" stop-opacity="0.05"/>
      <stop offset="100%" stop-color="#020308" stop-opacity="0.82"/>
    </radialGradient>
  </defs>
  <ellipse cx="32" cy="32" rx="30" ry="11" fill="none" stroke="#4FACFE"
           stroke-width="1.4" opacity="0.55" transform="rotate(-30 32 32)"/>
  <circle cx="26" cy="32" r="20" fill="url(#glow)"/>
  <circle cx="32" cy="32" r="17" fill="url(#globe)"/>
  <circle cx="32" cy="32" r="17" fill="url(#night)"/>
  <ellipse cx="29" cy="31" rx="8" ry="10" fill="#1A2A22" opacity="0.55"/>
  <ellipse cx="38" cy="36" rx="5" ry="3.2" fill="#1A2A22" opacity="0.4"/>
  <circle cx="32" cy="32" r="18.2" fill="none" stroke="#4FACFE" stroke-width="1.6" opacity="0.55"/>
</svg>
"""


def main() -> None:
    write(WEB / "favicon.svg", SVG.encode("utf-8"))
    write(WEB / "favicon.png", paint_earth(32))
    write(ICONS / "Icon-192.png", paint_earth(192))
    write(ICONS / "Icon-512.png", paint_earth(512))
    write(ICONS / "Icon-maskable-192.png", paint_earth(192, maskable=True))
    write(ICONS / "Icon-maskable-512.png", paint_earth(512, maskable=True))
    write(ICONS / "AppleTouchIcon.png", paint_earth(180))


if __name__ == "__main__":
    main()
