#!/usr/bin/env bash
set -euo pipefail

# Fetch a profile/avatar image from a url, scale + optimize it into
# avatar.png, rebuild the CV, and commit -- one streamlined step. A
# github profile url (no extension) resolves to its avatar via the .png
# suffix github serves. Commits only when something actually changed.

url="${1:-}"
if [ -z "$url" ]; then
  echo "usage: just photo <url>" >&2
  exit 1
fi

case "$url" in
  *.png | *.jpg | *.jpeg | *.webp) src="$url" ;;
  *) src="${url%/}.png" ;;
esac

raw="$(mktemp)"
scaled="$raw.png"
trap 'rm -f "$raw" "$scaled"' EXIT

curl -fsSL "$src" -o "$raw"
magick "$raw" -resize 320x320 "$scaled"
pngquant --quality=60-82 --strip --force --output avatar.png "$scaled"

bash scripts/build.sh
bash scripts/text.sh

git add avatar.png cv.pdf cv.txt
if git diff --cached --quiet; then
  echo "photo unchanged; nothing to commit"
else
  git commit -m "cv: update photo from $src"
fi
