#!/usr/bin/env bash
set -euo pipefail

rev=$(git rev-parse --short HEAD)

output=$(typst compile --input "rev=$rev" cv.typ cv.pdf 2>&1) || {
  echo "$output" >&2
  exit 1
}

if [ -n "$output" ]; then
  echo "$output" >&2
  exit 1
fi
