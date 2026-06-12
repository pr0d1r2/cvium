#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
gitignore="$root/.gitignore"

if [ ! -f "$gitignore" ]; then
  echo "missing: .gitignore" >&2
  exit 1
fi

for pattern in cv.local.typ cv.local.pdf; do
  if ! grep -qxF "$pattern" "$gitignore"; then
    echo "missing gitignore entry: $pattern" >&2
    exit 1
  fi
done
