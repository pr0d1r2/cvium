# shellcheck shell=bash
set -euo pipefail
typst compile --input "rev=$REV" cv.typ cv.pdf
