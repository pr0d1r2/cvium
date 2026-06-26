#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/nix/package/install.sh"

  export out="$BATS_TEST_TMPDIR/output.pdf"
  touch "$BATS_TEST_TMPDIR/cv.pdf"
}

@test "installs cv.pdf to output path" {
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
  [ -f "$out" ]
}

@test "fails when cv.pdf missing" {
  rm "$BATS_TEST_TMPDIR/cv.pdf"
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}
