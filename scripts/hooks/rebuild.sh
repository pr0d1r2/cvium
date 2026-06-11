#!/usr/bin/env bash
set -euo pipefail

typst compile cv.typ cv.pdf
git add cv.pdf
pdftotext -layout cv.pdf cv.txt
git add cv.txt
