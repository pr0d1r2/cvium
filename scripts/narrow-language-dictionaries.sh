#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
dics=(
  ".narrow-language-markdown.dic"
  ".narrow-language-nix.dic"
  ".narrow-language-other.dic"
  ".narrow-language-shell.dic"
)

for dic in "${dics[@]}"; do
  path="$root/$dic"
  if [ ! -f "$path" ]; then
    echo "missing: $dic" >&2
    exit 1
  fi
  if grep -qP '^\s*$' "$path"; then
    echo "empty line in: $dic" >&2
    exit 1
  fi
  if ! LC_ALL=C sort -c "$path" 2>/dev/null; then
    echo "unsorted: $dic" >&2
    exit 1
  fi
  if [ "$(LC_ALL=C sort -u "$path" | wc -l)" -ne "$(wc -l <"$path")" ]; then
    echo "duplicates in: $dic" >&2
    exit 1
  fi
done
