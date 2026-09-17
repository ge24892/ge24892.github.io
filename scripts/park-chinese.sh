#!/usr/bin/env bash
# Park the Chinese site (see also scripts/restore-chinese.sh).
#
# Two things have to happen together, because Zola errors on a `.zh.md` file when
# its language is not configured:
#   1. move content/**.zh.md and **.zh.toml to zh-content/
#   2. comment out the [languages.zh] and [languages.zh.translations] tables
#
# Usage:  ./scripts/park-chinese.sh
# Reverse: ./scripts/restore-chinese.sh

set -euo pipefail
cd "$(dirname "$0")/.."

lang=zh
parked=zh-content

# 1. move the Chinese content out of content/
mapfile -t files < <(find content \( -name "*.$lang.md" -o -name "*.$lang.toml" \) | sort)
if [ "${#files[@]}" -gt 0 ]; then
  for f in "${files[@]}"; do
    rel="${f#content/}"
    mkdir -p "$parked/$(dirname "$rel")"
    git mv "$f" "$parked/$rel"
  done
  echo "moved ${#files[@]} file(s) to $parked/"
else
  echo "content/ has no *.$lang.* files (already parked)"
fi

# 2. comment out the language tables
python3 - "$lang" "$parked" <<'PY'
import re, sys, tomllib

lang, parked = sys.argv[1], sys.argv[2]
path = 'zola.toml'
lines = open(path).read().split('\n')

header = [
    '# ----------------------------------------------------------------------------',
    f'# Chinese is parked: the [languages.{lang}*] tables below are commented out and the',
    f'# Chinese content lives in {parked}/ instead of content/ (Zola errors on a .{lang}.md',
    '# file while its language is not configured).',
    '# Run scripts/restore-chinese.sh to bring it back.',
    '# ----------------------------------------------------------------------------',
]

def is_table(line, name):
    return re.fullmatch(r'\[' + re.escape(name) + r'\]', line) is not None

def comment(block_lines):
    return [('# ' + l) if l.strip() else '#' for l in block_lines]

zh_lang = next(i for i, l in enumerate(lines) if is_table(l, f'languages.{lang}'))
translations = next(i for i, l in enumerate(lines) if is_table(l, 'translations'))
zh_trans = next(i for i, l in enumerate(lines) if is_table(l, f'languages.{lang}.translations'))
# the zh translations table is not necessarily the last table in the file, so it
# ends at the next table header (or EOF)
zh_trans_end = next((i for i in range(zh_trans + 1, len(lines)) if lines[i].startswith('[')),
                    len(lines))

out = (lines[:zh_lang]
       + header
       + comment(lines[zh_lang:translations])
       + lines[translations:zh_trans]
       + comment(lines[zh_trans:zh_trans_end])
       + lines[zh_trans_end:])
text = '\n'.join(out)
parsed = tomllib.loads(text)
assert lang not in parsed.get('languages', {}), f'languages.{lang} is still active'
assert 'extra' in parsed and 'markdown' in parsed, 'parking must not comment out other tables'
assert lang + '.md' not in str(parsed)
assert f'[languages.{lang}]' in ''.join(out), 'the table text should be preserved as comments'
open(path, 'w').write(text if text.endswith('\n') else text + '\n')
print(f'commented out [languages.{lang}] and [languages.{lang}.translations]')
PY

echo
echo "content/ now has: $(find content -name "*.md" | wc -l) markdown files"
echo "next: zola build"
