#!/usr/bin/env python3
"""Fail if a layout-affecting change was made for one language only.

Layout itself comes from shared templates, so those are identical for / and /zh/
by construction. What is *not* shared is the per-language configuration inside
`content/`:

  * the `[extra]` block of a section's `_index.md` / `_index.zh.md`
    (`footer`, `recent_max`, `back_to_top`, `back_to_home`, `date_format`, ...)
  * component calls in the content, e.g. the project list on the home page
  * `layout` / `flow` in a collection's data file (`projects.toml` / `projects.zh.toml`)

This script pairs each English file with its `.zh.md` sibling and reports
everything that exists on only one side, so a change like "show the project
cards on the home page" cannot accidentally ship for English only.

Run it any time (it only reads `content/`):

    python3 scripts/check-language-parity.py
"""

import pathlib
import re
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent


CONTENT = ROOT / "content"
LANG_SUFFIX = ".zh"  # non-default language

# Keys that only exist on one side on purpose:
# every Chinese section sets `date_format`, English sections inherit the
# site-wide value from zola.toml.
ALLOWED_ONE_SIDED_EXTRA_KEYS = {"date_format"}

# If the language is not configured in zola.toml (content parked, see
# scripts/park-chinese.sh), there is nothing to compare — the English site is
# allowed to be alone.
import tomllib as _tomllib

_config = _tomllib.loads((ROOT / "zola.toml").read_text())
if LANG_SUFFIX.lstrip(".") not in _config.get("languages", {}):
    print(f"language '{LANG_SUFFIX.lstrip('.')}' is not configured in zola.toml — parity check skipped")
    raise SystemExit(0)


def counterpart(path: pathlib.Path) -> pathlib.Path:
    """index.md -> index.zh.md, projects.toml -> projects.zh.toml"""
    return path.with_name(path.stem + LANG_SUFFIX + path.suffix)


def parse_front_matter(path: pathlib.Path) -> dict:
    text = path.read_text()
    if not text.startswith("+++"):
        return {}
    end = text.find("+++", 3)
    return tomllib.loads(text[3:end])


def body(path: pathlib.Path) -> str:
    text = path.read_text()
    if not text.startswith("+++"):
        return text
    return text[text.find("+++", 3) + 3 :]


def components(text: str) -> list[str]:
    """Names of Tera components called from the content, e.g. `collection`."""
    return sorted(re.findall(r"\{\{\s*<([A-Za-z_][\w]*)", text))


problems: list[str] = []

for english in sorted(CONTENT.rglob("*")):
    if english.name.endswith(LANG_SUFFIX + english.suffix) or LANG_SUFFIX in english.stem:
        continue  # handled from the English side
    if english.suffix not in (".md", ".toml") or english.name.startswith("."):
        continue

    chinese = counterpart(english)
    rel = english.relative_to(ROOT)

    if not chinese.exists():
        # Sections must exist in both languages (Zola has no section fallback);
        # pages are allowed to exist in one language only.
        if english.name == "_index.md":
            problems.append(f"{rel}: missing {chinese.name} (every section needs both languages)")
        continue

    if english.suffix == ".toml":
        en, zh = parse_front_matter(english), parse_front_matter(chinese)
        for key in ("layout", "flow"):
            if en.get(key) != zh.get(key):
                problems.append(
                    f"{rel}: `{key}` differs between {english.name} ({en.get(key)!r}) "
                    f"and {chinese.name} ({zh.get(key)!r})"
                )
        continue

    en_extra = set(parse_front_matter(english).get("extra", {}))
    zh_extra = set(parse_front_matter(chinese).get("extra", {}))
    for key in sorted(en_extra ^ zh_extra):
        if key in ALLOWED_ONE_SIDED_EXTRA_KEYS:
            continue
        side = english.name if key in en_extra else chinese.name
        problems.append(f"{rel}: `[extra] {key}` exists only in {side}")

    en_components, zh_components = components(body(english)), components(body(chinese))
    if en_components != zh_components:
        problems.append(
            f"{rel}: component calls differ — {english.name} has {en_components}, "
            f"{chinese.name} has {zh_components}"
        )

if problems:
    print("Layout parity problems between languages:")
    for problem in problems:
        print("  -", problem)
    sys.exit(1)

print("language parity check OK")
