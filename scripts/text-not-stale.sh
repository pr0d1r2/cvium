#!/usr/bin/env bash
set -euo pipefail

tmp_pdf=$(mktemp)
tmp_txt=$(mktemp)
trap 'rm -f "$tmp_pdf" "$tmp_txt"' EXIT
typst compile cv.typ "$tmp_pdf"
pdftotext -layout "$tmp_pdf" "$tmp_txt"
cmp -s cv.txt "$tmp_txt" || {
  echo "cv.txt is stale — regenerate with: just text" >&2
  exit 1
}
