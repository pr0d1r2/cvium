#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/photo.sh"

  export URLLOG="$BATS_TEST_TMPDIR/url.log"
  export GITLOG="$BATS_TEST_TMPDIR/git.log"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/curl" <<'EOF'
#!/usr/bin/env bash
out=""
url=""
while [ $# -gt 0 ]; do
case "$1" in
-o) shift; out="$1" ;;
-*) : ;;
*) url="$1" ;;
esac
shift
done
echo "$url" >"$URLLOG"
printf raw >"$out"
EOF

  cat >"$STUB/magick" <<'EOF'
#!/usr/bin/env bash
cp "$1" "${@: -1}"
EOF

  cat >"$STUB/pngquant" <<'EOF'
#!/usr/bin/env bash
out=""
while [ $# -gt 0 ]; do
case "$1" in
--output) shift; out="$1" ;;
esac
shift
done
printf optimized >"$out"
EOF

  cat >"$STUB/typst" <<'EOF'
#!/usr/bin/env bash
printf pdf >"${@: -1}"
EOF

  cat >"$STUB/pdftotext" <<'EOF'
#!/usr/bin/env bash
printf txt >"${@: -1}"
EOF

  cat >"$STUB/git" <<'EOF'
#!/usr/bin/env bash
case "$1" in
add) exit 0 ;;
diff) exit 1 ;;
commit) shift; [ "$1" = "-m" ] && echo "$2" >"$GITLOG"; exit 0 ;;
esac
exit 0
EOF

  chmod +x "$STUB"/*
  PATH="$STUB:$PATH"

  # Sandbox repo root with the scripts photo.sh chains to.
  mkdir -p "$BATS_TEST_TMPDIR/work/scripts"
  cp "$REPO/scripts/build.sh" "$REPO/scripts/text.sh" \
    "$BATS_TEST_TMPDIR/work/scripts/"
  : >"$BATS_TEST_TMPDIR/work/cv.typ"
  cd "$BATS_TEST_TMPDIR/work" || return 1
}

@test "errors without a url" {
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "usage: just photo"
}

@test "github profile url resolves to the .png avatar" {
  run bash "$SCRIPT" https://github.com/pr0d1r2
  assert_success
  assert_equal "$(cat "$URLLOG")" "https://github.com/pr0d1r2.png"
  assert [ -f avatar.png ]
}

@test "explicit image url is used as-is" {
  run bash "$SCRIPT" https://example.com/me.png
  assert_success
  assert_equal "$(cat "$URLLOG")" "https://example.com/me.png"
}

@test "trailing slash is stripped before adding .png" {
  run bash "$SCRIPT" https://github.com/pr0d1r2/
  assert_success
  assert_equal "$(cat "$URLLOG")" "https://github.com/pr0d1r2.png"
}

@test "rebuilds the CV and commits on success" {
  run bash "$SCRIPT" https://github.com/pr0d1r2
  assert_success
  assert [ -f cv.pdf ]
  assert [ -f cv.txt ]
  assert_equal "$(cat "$GITLOG")" "cv: update photo from https://github.com/pr0d1r2.png"
}
