#!/usr/bin/env bash
set -euo pipefail

rev=$(git rev-parse --short HEAD)
typst compile --input "rev=$rev" cv.typ cv.pdf
git add cv.pdf
pdftotext -layout cv.pdf cv.txt
git add cv.txt
