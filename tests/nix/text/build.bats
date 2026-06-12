#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/nix/text/build.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
touch cv.pdf
exit 0
STUB
  chmod +x "$STUB/typst"

  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
touch cv.txt
exit 0
STUB
  chmod +x "$STUB/pdftotext"

  PATH="$STUB:$PATH"
  export REV="abc1234"
}

@test "compiles cv.typ then converts to cv.txt" {
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
}

@test "passes --input rev=REV to typst" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "rev=abc1234" ]; then
    touch cv.pdf
    exit 0
  fi
done
echo "missing --input rev=abc1234" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
}

@test "calls pdftotext with -layout flag" {
  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "-layout" ]; then
    touch cv.txt
    exit 0
  fi
done
echo "missing -layout flag" >&2
exit 1
STUB
  chmod +x "$STUB/pdftotext"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
}

@test "fails when typst compile fails" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
echo "error: file not found" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}

@test "fails when pdftotext fails" {
  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
echo "error: conversion failed" >&2
exit 1
STUB
  chmod +x "$STUB/pdftotext"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}
