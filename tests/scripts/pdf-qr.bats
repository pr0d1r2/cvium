#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/pdf-qr.sh"

  mkdir -p "$BATS_TEST_TMPDIR/work"
  cd "$BATS_TEST_TMPDIR/work" || return 1
}

@test "passes when QR code hyperlink present" {
  printf '/URI (https://github.com/pr0d1r2/cvium/releases/latest)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_success
}

@test "fails when QR code hyperlink missing" {
  printf '/URI (mailto:marcin@prodix.pl)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "missing QR code hyperlink"
}
