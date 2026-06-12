#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/test.sh"
}

@test "test.sh exists and is executable" {
  [ -x "$SCRIPT" ]
}

@test "calls bats" {
  run grep -q "bats" "$SCRIPT"
  assert_success
}
