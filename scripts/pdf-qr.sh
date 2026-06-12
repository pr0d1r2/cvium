#!/usr/bin/env bash
set -euo pipefail

expected="https://github.com/pr0d1r2/cvium/releases/latest"
if ! grep -aqF "/URI ($expected)" cv.pdf; then
  echo "missing QR code hyperlink: $expected" >&2
  exit 1
fi
