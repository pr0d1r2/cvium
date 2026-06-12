#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/nix/dev/shell.sh"
}

@test "shell.sh exists" {
  [ -f "$SCRIPT" ]
}

@test "calls lefthook install" {
  run grep -q "lefthook install" "$SCRIPT"
  assert_success
}
