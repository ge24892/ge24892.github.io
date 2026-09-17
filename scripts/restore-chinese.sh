#!/usr/bin/env bash
# Reverse scripts/park-chinese.sh: bring the Chinese site back.
#
#   1. move zh-content/** back into content/
#   2. uncomment the [languages.zh] and [languages.zh.translations] tables
#
# Usage:  ./scripts/restore-chinese.sh
# Then:   zola build   (and push — remember both languages share one layout)

set -euo pipefail
cd "$(dirname "$0")/.."

parked=zh-content

# 1. move the content back
if [ -d "$parked" ]; then
  moved=$(find "$parked" -type f | wc -l)
  (cd "$parked" && find . -type f | sed 's|^\./||' | while IFS= read -r f; do
    mkdir -p "../content/$(dirname "$f")"
    git mv "$f" "../content/$f"
  done)
  find "$parked" -type d -empty -delete 2>/dev/null || true
  echo "moved $moved file(s) back into content/"
else
  echo "$parked/ not found — nothing to move"
fi

# 2. uncomment the language tables
python3 <<'PY'
import re, tomllib

path = 'zola.toml'
lines = open(path).read().split('\n')

separators = [i for i, l in enumerate(lines) if l.startswith('# ---')]
if len(separators) >= 2:
    drop = set(range(separators[0], separators[1] + 1))     # the park header
    lines = [l for i, l in enumerate(lines) if i not in drop]

def uncomment(line):
    if line == '#':
        return ''
    if line.startswith('# '):
        return line[2:]
    if line.startswith('#'):
        return line[1:]
    return line

def uncomment_run(lines, start):
    end = start
    while end < len(lines) and lines[end].startswith('#'):
        end += 1
    lines[start:end] = [uncomment(l) for l in lines[start:end]]

for table in ('[languages.zh.translations]', '[languages.zh]'):
    i = next(i for i, l in enumerate(lines) if l == '# ' + table)
    uncomment_run(lines, i)

assert 'extra' in tomllib.loads('\n'.join(lines)), 'restore broke another table'
text = '\n'.join(lines)
parsed = tomllib.loads(text)
assert 'zh' in parsed.get('languages', {}), 'the zh language table did not come back'
open(path, 'w').write(text if text.endswith('\n') else text + '\n')
print('uncommented the zh language tables')
PY

echo
echo "next: zola build && zola serve   (zola.toml changed, so restart the server)"
