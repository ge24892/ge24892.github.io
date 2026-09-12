# ge24892.github.io

Portfolio site built with [Zola](https://www.getzola.org) and the
[serene](https://www.getzola.org/themes/serene/) theme, published to GitHub
Pages. The site is bilingual: **English at `/`, Chinese at `/zh/`**.

## Local development

Zola **0.23.4 or newer** is required (the theme declares `min_version = "0.23.4"`).

```sh
zola serve          # http://127.0.0.1:1111 with live reload
zola build          # writes the site to public/
zola check          # validate templates and internal links
```

Everything under `themes/` and `public/` should never be edited by hand. To
override a theme file, copy it to the same path outside `themes/` (for example
`themes/serene/templates/_custom_css.html` → `templates/_custom_css.html`) and
edit the copy.

## Layout

```
zola.toml                       site config: languages, nav, links, translation tables
content/
├── _index.md                   home page: intro + project cards (+ redirect from /projects/)
├── _index.zh.md                中文首页（+ /zh/projects/ 重定向）
├── posts/
│   ├── _index.md               blog list section (empty for now)
│   └── _index.zh.md            文章列表
├── projects/
│   ├── _index.md               render = false — hosts the project pages, has no page of its own
│   ├── _index.zh.md            同上（中文）
│   ├── projects.toml           English project list (rendered on the home page)
│   ├── projects.zh.toml        Chinese project list (rendered on 首页)
│   └── blackjack/index.md      BlackJack project page (images/videos colocated here)
└── about/_index.md             prose page
    about/_index.zh.md          关于页
static/img/                     avatar.webp + favicons (generated from profile.jpg)
profile.jpg                     source photo for the avatar and the favicons
templates/                      theme overrides — see "Theme overrides" below
scripts/theme-overrides.sh      regenerates theme-overrides.diff
scripts/check-i18n-links.py     fails if a /zh/ page links to an English page
scripts/check-language-parity.py fails if a layout change was made for one language only
theme-overrides.diff            snapshot of every change made to the theme
themes/serene/                  git submodule, do not edit
.github/workflows/deploy.yml     build + deploy to GitHub Pages on push to main
```

## How the two languages work

> **Rule: every layout change must be made for both languages.** Templates are
> shared, so markup edits apply to `/` and `/zh/` automatically. What is *not*
> shared is the per-language config inside `content/`: the `[extra]` block of a
> section's `_index.md` / `_index.zh.md` (`footer`, `recent_max`, `back_to_top`,
> `back_to_home`, …), component calls in the content (e.g. the project list on
> the home page) and `layout` / `flow` in the collection `.toml` files. Whenever
> one of those changes, change the matching `.zh.md` / `.zh.toml` file in the
> same commit — `scripts/check-language-parity.py` blocks the deploy otherwise.

Zola detects the language of a content file from its filename suffix:
`_index.md` / `article.md` are the default language (English), `_index.zh.md` /
`article.zh.md` are Chinese. Chinese pages are published under `/zh/…`.

Things worth knowing, all of which are easy to trip over:

- **Every `_index.md` needs a matching `_index.zh.md`.** Zola has no language
  fallback for sections; a missing file makes the whole section disappear from
  the Chinese site.
- **`taxonomies` and `feed_filenames` are not inherited** by `[languages.zh]`.
  They are repeated in `zola.toml`; without `feed_filenames` the Chinese feed
  would be written as `atom.xml` (Zola's built-in template) instead of
  `feed.xml` (the theme's).
- **There is no `[languages.zh.extra]`.** Zola only supports `title`,
  `description`, `generate_feeds`, `feed_filenames`, `taxonomies`,
  `build_search_index`, `search` and `translations` per language. Everything
  translatable therefore lives in the `[translations]` /
  `[languages.zh.translations]` tables and is rendered with `trans(key="…")` in
  the overridden templates.
- **A missing translation key is a hard build error**, and keys are looked up
  with an explicit `lang` or the language of the current page. So each key must
  be defined in *both* translation tables.
- **UI strings in components must be passed in.** Tera components (the pieces in
  `templates/_components/`) are rendered with an isolated context: they cannot
  see `lang`, `page` or `config` unless a parameter is passed. That is why the
  back-link text is handed to the `back_link` component as
  `text={trans(key="back")}` instead of being translated inside it.
- **Zola renders only one 404 page**, in the default language, so `/404.html` is
  always English.
- **`get_url` with a plain path is language-blind.** `get_url(path="/about")`
  always returns the *default* language's URL — only `@/...` paths follow the
  active language, and plain paths need an explicit `lang={lang}`. The nav row,
  the back links and the home page's canonical URL are all written with this in
  mind; `scripts/check-i18n-links.py` fails the build if a page under `/zh/`
  links outside `/zh/` (relative links included). Exceptions: the language
  switcher, and any link carrying an explicit `hreflang` attribute — set
  `link_lang = "en"` on a collection item whose page only exists in English.
- **Declared taxonomies are always listed in `sitemap.xml`**, even when they have
  no terms yet: `/tags/` and `/zh/tags/` are in the sitemap but return 404 until
  a post actually uses a tag. If you never want tags, drop
  `taxonomies = [{ name = "tags" }]` from both the top level and `[languages.zh]`.
  (`categories` was already removed: serene has no category page, its template
  just redirects to the home page.)
- Pages may exist in one language only: a post with just `index.zh.md` (no
  English file) is fine, and its language switcher falls back to the other
  language's home page.
- Chinese filenames are transliterated to pinyin for the URL —
  `content/posts/测试文章/index.zh.md` becomes `/zh/posts/ce-shi-wen-zhang/`. Add
  `slug = "…"` to the front matter if you want a specific URL.

### Translation keys (`zola.toml`)

| Key | Where it is used |
| --- | --- |
| `name`, `bio` | home page name and one-line bio |
| `nav_projects`, `nav_about`, `nav_posts`, `nav_github` | home page nav labels — `[extra] nav[].name` holds the *key*, not the label |
| `back` | “← Back” link on post / list / prose pages |
| `tags` | heading of the tag pages (`/tags/`, `/zh/tags/`) |
| `footer_copyright` | footer, left side |
| `footer_credits_before` / `_and` / `_after` | footer credits, wrapped around the links to zola and serene (“Built with zola and serene” / “由 zola 和 serene 构建”) |

Language display names (used by the switcher) are the one thing that is *not*
translated — they live in `[extra] lang_names` as `{ en = "English", zh = "中文" }`.

Section-specific strings (titles, subtitles, `recent_more_text`, date formats)
belong in the front matter of each `_index.{lang}.md`, so they are edited per
language. Every Chinese section sets `date_format = "%Y年%-m月%-d日"` in its
`[extra]` block — add the same line to any new Chinese section, otherwise its
dates fall back to the site-wide English format.

### Language switcher and SEO

`templates/_lang_switch.html` renders one link per other language, pointing at
the same page when a translation exists and at that language's home page
otherwise. It is included in the home page nav row
(`templates/home.html`) and in the footer of every other page
(`templates/_footer.html`).

`templates/_lang_alternates.html` adds `<link rel="alternate" hreflang="…">`
tags (plus `x-default`) to the `<head>` of pages that have translations, so
search engines know about both versions.

### Automatic language selection

`templates/_lang_redirect.html` is included right after those tags (still in
`<head>`, so it runs before the body is painted — no flash of the wrong
language) and sends first-time visitors to the language their browser asks for.
The signals, in order of precedence:

1. `?lang=en` / `?lang=zh` in the URL — wins over everything, and is remembered
2. the language the visitor picked earlier with the switcher (`localStorage`)
3. `navigator.languages` / `navigator.language`
4. the time zone (Chinese zones → Chinese), only when the browser language gives
   no usable signal at all, e.g. `fr`

The redirect target is the page's own `hreflang` alternate, so a page that exists
in only one language never redirects — `/projects/blackjack/` stays English even
for a Chinese browser. An explicit choice with the switcher always wins from then
on, so nobody gets bounced back and forth.

Disable it with `lang_auto_redirect = false` in `[extra]` of `zola.toml`. Because
the site is static this has to be JavaScript: crawlers (which report `en`) and
visitors with the setting off see exactly the URL they requested, and `hreflang`
+ `x-default` remain the search-engine signal. To test: `/?lang=zh` should land on
`/zh/`, and `/zh/?lang=en` on `/`.

### Chinese typography

`templates/_custom_css.html` adds a `body:lang(zh)` rule that switches
`--main-font` to a CJK stack (Noto Sans SC, PingFang SC, Microsoft YaHei, …) and
raises `--line-height` to `1.9`. Nothing is downloaded: the fonts are the ones
already installed on the visitor's device.

## What to fill in

**Status:** the Chinese pages are filled in (from the resume), the English pages
are still placeholders.

English:

1. `zola.toml` — `title`, `description`, `handle`, `links`, `og_image`, and the
   English translation table (`name`, `bio`, `footer_copyright`).
2. `profile.jpg` — the source photo for the profile picture and the browser icon.
   Regenerate the derived images with `./scripts/make-images.sh`, which writes
   `static/img/avatar.webp` (320×320 webp, shown as a 60 px square on the home
   page) plus `favicon-32x32.png`, `favicon-16x16.png` and
   `apple-touch-icon.png` (180×180). If the face is off-centre, adjust
   `face_crop` at the top of that script — it holds `WIDTHxHEIGHT+X+Y` in source
   pixels.
3. `content/_index.md` — home page intro.
4. `content/about/_index.md` — your bio.
5. `content/projects/projects.toml` — replace the placeholder items.
6. `content/projects/blackjack/index.md` — the migrated BlackJack writeup
   (captions are placeholders, the media is grouped at the bottom), listed in
   `content/projects/projects.toml` and `projects.zh.toml`.

Chinese (all marked `TODO`):

7. `zola.toml` — `[languages.zh]` title/description and the
   `[languages.zh.translations]` table (`name`, `bio`, `footer_copyright`).
8. `content/_index.zh.md`, `content/about/_index.zh.md`,
   `content/projects/_index.zh.md` and `content/projects/projects.zh.toml`.

Note: the videos in the BlackJack post are ~30 MB in total. If the repository
gets too heavy, host them elsewhere (e.g. YouTube) and embed them with
`{{ <youtube id="<video-id>" /> }}` instead.

## Adding a post

English:

```sh
mkdir -p content/posts/my-post
$EDITOR content/posts/my-post/index.md
```

Chinese — same directory, `index.zh.md` suffix (it can exist on its own, without
an English version):

```sh
mkdir -p content/posts/my-post
$EDITOR content/posts/my-post/index.zh.md
```

```md
+++
title = "标题"
description = "一句话摘要。"
date = 2026-09-12

[taxonomies]
tags = ["标签"]

[extra]
lang = "zh"      # sets <html lang> and the CJK font rules
toc = true
+++

正文。放在同一目录下的图片可以用
`{{ <figure src="picture.png" caption="图注" page /> }}` 引用。
```

Colocated assets (images, videos) are copied to both `/posts/my-post/` and
`/zh/posts/my-post/`, so the same files can be used by both language versions.
Videos referenced in raw HTML use a relative `src="video.mp4"`.

### Adding a project

The projects section has `page_template = "post.html"` and `render = false`:
it exists only to host the project pages, its list lives on the **home page**.
A project page is therefore a normal page inside `content/projects/`:

```sh
mkdir -p content/projects/my-project
$EDITOR content/projects/my-project/index.md
```

Project pages need a `date` in the front matter (like the BlackJack one does),
because the theme prints it under the title. Then add an entry to
`content/projects/projects.toml` — and to `projects.zh.toml` for the Chinese
page, the two lists are independent files. The cards show up on the home page
(`/` and `/zh/`):

```toml
[[item]]
title = "My project"
subtitle = "one-liner"
content = "What it does, what you built it with."
image = "/projects/my-project/cover.jpg"   # optional
link = "/projects/my-project/"
badge = "2026"
tags = ["rust", "cli"]
```

If a project page only exists in one language while the list is shown in both,
point the other language's card at it and mark the language with `link_lang`:

```toml
link = "/projects/my-project/"
link_lang = "en"   # keeps the i18n link checker happy
```

See `themes/serene/USAGE.md` for everything else the theme supports
(collections, callouts, KaTeX, Mermaid, giscus comments, emoji reactions, …).

## Adding a third language

1. Add the display name to `[extra] lang_names`.
2. Add a `[languages.xx]` table with `title`, `description`, `taxonomies` and
   `feed_filenames`.
3. Add a `[languages.xx.translations]` table with **every** key listed above.
4. Copy each `_index.md` to `_index.xx.md` and translate the front matter.
5. If the language needs different fonts or line height, add a
   `body:lang(xx)` rule in `templates/_custom_css.html`.

The switcher and the `hreflang` tags pick the new language up automatically.

## Small customisations

- **Home page icon row** — `[extra] links` in `zola.toml` is empty, so the home
  page only shows the light/dark switch. Uncomment an entry to bring the icon
  links back.
- **Square avatar** — `html body.homepage #info img { border-radius: 0 }` in
  `templates/_custom_css.html` (use e.g. `8px` for a rounded square). The image
  itself comes from `scripts/make-images.sh`; removing `avatar` from `[extra]`
  hides it again without deleting the file.
- **Social preview image** — not set, so link previews have no picture. Generate
  a 1200×630 crop (e.g. `magick profile.jpg -crop … -resize 1200x630 static/img/og.png`)
  and set `og_image = "img/og.png"` in `[extra]`.
- **Empty blog** — `content/posts/` has no posts right now, so `/posts/` renders
  an empty list and the home page's recent list hides itself automatically. If
  you don't want a blog at all, set `recent = false` in `content/_index.md` and
  `content/_index.zh.md` first, then delete `content/posts/` (the recent list
  would otherwise fail to find the section).
- **Projects live on the home page** — `content/projects/_index.md` has
  `render = false`, so `/projects/` is not built; instead each home page declares
  `aliases = ["/projects/"]` (and `["/zh/projects/"]`) which makes Zola emit a
  redirect page there. Project detail URLs are unaffected
  (`/projects/blackjack/`, `/zh/projects/lerobot-wam/`). The `back_to_home = true`
  flag in those sections' `[extra]` points their “← Back” link at the home page.
- **Old URLs** — `/posts/blackjack/` still works: the page's front matter has
  `aliases = ["/posts/blackjack/"]`, which makes Zola emit a redirect page.

## Theme overrides

The theme is a submodule, so customisations live in `templates/` (which takes
precedence over `themes/serene/templates/`). `theme-overrides.diff` is a
per-file snapshot of every change; regenerate it with:

```sh
./scripts/theme-overrides.sh
```

| File | Change |
| --- | --- |
| `_base.html` | include `_lang_alternates.html` and `_lang_redirect.html` in `<head>` |
| `home.html` | `trans()` for name/bio/nav labels, language switcher in the nav row, hide the recent list when the language has no posts yet |
| `_footer.html` | `trans()` for copyright/credits, language switcher |
| `post.html` | pass `text={trans(key="back")}` to the back-link component; `back_to_home = true` in a section's `[extra]` sends its pages' back link to the home page |
| `posts.html`, `prose.html` | pass `text={trans(key="back")}` to the back-link component, back link points at the current language's home |
| `tags/list.html`, `tags/single.html` | `trans()` for the “Tags” heading and the back link |
| `_components/prose.html` | `back_link` takes a `text` parameter (components cannot see the page language) |
| `_components/collection.html` | optional `path` parameter (the default lookup is `content/<section.path>/<file>`, which for the home page would be `content/projects.toml`), and `link_lang` → `hreflang` on card links |
| `_custom_css.html` | CJK font stack and line height for `:lang(zh)`, square avatar, styling for the footer language switcher |
| `_lang_switch.html`, `_lang_alternates.html`, `_lang_redirect.html` | new files, not present in the theme (switcher, hreflang tags, browser-language redirect) |

## Deploying

`.github/workflows/deploy.yml` builds the site with a pinned Zola version and
publishes `public/` to GitHub Pages on every push to `main`. The build runs three
checks and stops before deploying if any of them fails:

1. `zola build` — config, templates, and **every translation key** (a missing key
   is a hard error)
2. `zola check` — broken internal links, malformed templates
3. `python3 scripts/check-i18n-links.py` — Chinese pages must not link to
   English pages
4. `python3 scripts/check-language-parity.py` — a layout-affecting change must
   not exist in one language only (per-language `[extra]` keys, component calls,
   collection `layout`/`flow`)

One-time setup in the repository settings:

> **Settings → Pages → Build and deployment → Source: GitHub Actions**

If a deployment fails because the Zola version is too old for the theme, bump
`ZOLA_VERSION` (and `ZOLA_SHA256`) in the workflow.

## Updating the theme

```sh
./scripts/theme-overrides.sh        # snapshot current customisations first
git submodule update --remote themes/serene
git diff theme-overrides.diff       # see what the theme changed
```

Then re-apply the changes from the table above to the matching files in
`templates/`, and `zola build` to check. Also re-read
`themes/serene/CHANGELOG.md` for breaking changes and compare
`themes/serene/zola.toml.example` with `zola.toml` for new options.
