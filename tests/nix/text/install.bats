#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/nix/text/install.sh"

  export out="$BATS_TEST_TMPDIR/output.txt"
  touch "$BATS_TEST_TMPDIR/cv.txt"
}

@test "installs cv.txt to output path" {
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
  [ -f "$out" ]
}

@test "fails when cv.txt missing" {
  rm "$BATS_TEST_TMPDIR/cv.txt"
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}
