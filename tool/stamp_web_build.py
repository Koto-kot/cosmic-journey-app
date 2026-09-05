#!/usr/bin/env python3
"""Stamp the Flutter web build with the git SHA and drop a public build.json."""

from __future__ import annotations

import json
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "app" / "build" / "web"
INDEX = WEB / "index.html"
NOT_FOUND = WEB / "404.html"

SHA = os.environ.get("COSMIC_BUILD_SHA") or os.environ.get("GITHUB_SHA") or "unknown"
REF = os.environ.get("COSMIC_BUILD_REF") or os.environ.get("GITHUB_REF_NAME") or "main"

META = f'<meta name="cosmic-journey-build" content="{SHA}">'
COMMENT = f"<!-- cosmic-journey-build {SHA} -->"


def stamp_html(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if "cosmic-journey-build" not in text:
        text = text.replace("</head>", f"  {META}\n  {COMMENT}\n</head>", 1)
    path.write_text(text, encoding="utf-8")


def main() -> None:
    WEB.mkdir(parents=True, exist_ok=True)
    payload = {"sha": SHA, "ref": REF, "pwaStrategy": "none"}
    (WEB / "build.json").write_text(
        json.dumps(payload, indent=2) + "\n", encoding="utf-8"
    )
    if INDEX.exists():
        stamp_html(INDEX)
    if NOT_FOUND.exists():
        stamp_html(NOT_FOUND)


if __name__ == "__main__":
    main()
