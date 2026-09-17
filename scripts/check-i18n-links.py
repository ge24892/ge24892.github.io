#!/usr/bin/env python3
"""Fail if a page under public/<lang>/ links to a page outside that language.

Why this exists: `get_url(path="/about")` with a plain path is language-blind in
Zola — only `@/...` paths follow the active language, and only an explicit
`lang=` argument adds the prefix to plain paths. So a single missed `lang={lang}`
silently sends Chinese visitors to the English page (this happened with the nav
row, the back links and the canonical URL).

Shared assets (css, js, images, icons, fonts) are language-neutral and allowed.
The language switcher is allowed to point at the other language by design, and so
is any link carrying an explicit `hreflang="..."` attribute (e.g. a project that
only exists in English: `link_lang = "en"` in a collection file).
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
LANGUAGES = ["zh"]  # non-default languages that must stay inside their own tree
SHARED_PREFIXES = (
    "/img/",
    "/js/",
    "/icon/",
    "/font/",
    "/main.css",
    "/giallo-light.css",
    "/giallo-dark.css",
    "/giscus_light.css",
    "/giscus_dark.css",
    "/robots.txt",
    "/sitemap.xml",
)

base_url = re.search(
    r'^base_url\s*=\s*"([^"]+)"', (ROOT / "zola.toml").read_text(), re.MULTILINE
).group(1).rstrip("/")


def is_allowed(path: str, lang: str) -> bool:
    if path == f"/{lang}" or path.startswith(f"/{lang}/"):
        return True
    return any(path.startswith(prefix) for prefix in SHARED_PREFIXES)


present = [lang for lang in LANGUAGES if (ROOT / "public" / lang).is_dir()]
if not present:
    print(f"no {'/'.join(LANGUAGES)}/ output — languages parked, link check skipped")
    raise SystemExit(0)

problems = []
for lang in LANGUAGES:
    for page in sorted((ROOT / "public" / lang).rglob("*.html")):
        for tag in re.findall(r"<a\b[^>]*>", page.read_text()):
            if 'class="lang-switch' in tag:  # points at the other language on purpose
                continue
            if 'hreflang="' in tag:  # explicitly marked as another language's content
                continue
            match = re.search(r'href="([^"]+)"', tag)
            if not match:
                continue
            url = match.group(1)
            # absolute links to this site, and relative links like /zh/projects/
            if url.startswith(base_url):
                path = url[len(base_url) :]
            elif url.startswith("/") and not url.startswith("//"):
                path = url
            else:
                continue  # external, mailto:, #anchor, ...
            if not is_allowed(path, lang):
                problems.append(f"{page.relative_to(ROOT)}: {url}")

if problems:
    print("Language-blind links found on non-default-language pages:")
    for problem in problems:
        print("  -", problem)
    sys.exit(1)

print("i18n link check OK")
