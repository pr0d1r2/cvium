#!/usr/bin/env bash
set -euo pipefail

if [ ! -f cv.local.typ ]; then
  echo "cv.local.typ not found — copy cv.local.example.typ and set your phone" >&2
  exit 1
fi

phone=$(sed -n 's/^#let phone = "\(.*\)"/\1/p' cv.local.typ)

if [ -z "$phone" ]; then
  echo "no phone found in cv.local.typ" >&2
  exit 1
fi

rev=$(git rev-parse --short HEAD)

output=$(typst compile --input "rev=$rev" --input "phone=$phone" cv.typ cv.local.pdf 2>&1) || {
  echo "$output" >&2
  exit 1
}

if [ -n "$output" ]; then
  echo "$output" >&2
  exit 1
fi
