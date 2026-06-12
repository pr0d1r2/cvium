#!/usr/bin/env bash
set -euo pipefail

rev=$(git rev-parse --short HEAD)
typst watch --input "rev=$rev" cv.typ cv.pdf
