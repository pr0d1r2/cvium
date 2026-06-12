#!/usr/bin/env bash
set -euo pipefail

missing=0
for expected in "mailto:marcin@prodix.pl" "https://github.com/pr0d1r2" "https://linkedin.com/in/pr0d1r2"; do
  if ! grep -aqF "/URI ($expected)" cv.pdf; then
    echo "missing hyperlink: $expected" >&2
    missing=1
  fi
done

if [ "$missing" -eq 1 ]; then
  exit 1
fi
