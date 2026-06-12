#!/usr/bin/env bash
set -euo pipefail

rev=$(git rev-parse --short HEAD)
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
typst compile --input "rev=$rev" cv.typ "$tmp"
cmp -s cv.pdf "$tmp" || {
  echo "cv.pdf is stale — recompile with: just build" >&2
  exit 1
}
