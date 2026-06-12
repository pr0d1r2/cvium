#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/pdf-links.sh"

  mkdir -p "$BATS_TEST_TMPDIR/work"
  cd "$BATS_TEST_TMPDIR/work" || return 1
}

@test "passes when all three hyperlinks present" {
  printf '/URI (mailto:marcin@prodix.pl)\n/URI (https://github.com/pr0d1r2)\n/URI (https://linkedin.com/in/pr0d1r2)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_success
}

@test "fails when email hyperlink missing" {
  printf '/URI (https://github.com/pr0d1r2)\n/URI (https://linkedin.com/in/pr0d1r2)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "missing hyperlink: mailto:marcin@prodix.pl"
}

@test "fails when GitHub hyperlink missing" {
  printf '/URI (mailto:marcin@prodix.pl)\n/URI (https://linkedin.com/in/pr0d1r2)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "missing hyperlink: https://github.com/pr0d1r2"
}

@test "fails when LinkedIn hyperlink missing" {
  printf '/URI (mailto:marcin@prodix.pl)\n/URI (https://github.com/pr0d1r2)\n' >"cv.pdf"
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "missing hyperlink: https://linkedin.com/in/pr0d1r2"
}
