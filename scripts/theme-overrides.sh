#!/usr/bin/env bash
# Regenerate theme-overrides.diff: a per-file snapshot of this site's
# customisations of themes/serene/templates/.
#
# Run this *before* updating the theme submodule, so you have a record of what
# to re-apply afterwards:
#
#   git submodule update --remote themes/serene
#   ./scripts/theme-overrides.sh && git diff theme-overrides.diff

set -euo pipefail
cd "$(dirname "$0")/.."
output="$(pwd)/theme-overrides.diff"

{
  cat <<'EOF'
# Snapshot of every change this site makes to the serene theme's templates.
#
# Files under templates/ take precedence over themes/serene/templates/, so these
# are the local customisations. Regenerate with:
#
#   ./scripts/theme-overrides.sh
#
# Files listed as "new file" do not exist in the theme at all.
# After `git submodule update --remote themes/serene`, re-apply these changes by
# hand — see the "Theme overrides" section of the README for a summary.
EOF
  cd templates
  for f in $(find . -type f | sed 's|^\./||' | sort); do
    t="../themes/serene/templates/$f"
    if [ -f "$t" ]; then
      if ! diff -q "$t" "$f" >/dev/null; then
        # `diff` exits 1 when the files differ, which `set -e`/`pipefail` would
        # treat as a failure, so ignore its exit status here.
        { diff -u "$t" "$f" || true; } | sed "1s|^--- .*|--- a/themes/serene/templates/$f|; 2s|^+++ .*|+++ b/templates/$f|"
      fi
    else
      echo "new file: templates/$f (not present in the theme)"
    fi
  done
} > "$output"

echo "wrote theme-overrides.diff ($(wc -l < "$output") lines)"
