#!/usr/bin/env bash
set -euo pipefail

pages=$(pdfinfo cv.pdf | grep '^Pages:' | sed 's/Pages:[[:space:]]*//')
if [ "$pages" -ne 2 ]; then
  echo "expected 2 pages, got $pages" >&2
  exit 1
fi
