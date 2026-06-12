#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/gitignore-local.sh"
}

@test "succeeds when both patterns are in .gitignore" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cv.local.typ\ncv.local.pdf\n' >"$DIR/.gitignore"
  run bash "$SCRIPT" "$DIR"
  assert_success
}

@test "fails when .gitignore is missing" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "missing: .gitignore"
}

@test "fails when cv.local.typ is missing from .gitignore" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cv.local.pdf\n' >"$DIR/.gitignore"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "cv.local.typ"
}

@test "fails when cv.local.pdf is missing from .gitignore" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cv.local.typ\n' >"$DIR/.gitignore"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "cv.local.pdf"
}

@test "defaults to current directory when no argument given" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cv.local.typ\ncv.local.pdf\n' >"$DIR/.gitignore"
  cd "$DIR"
  run bash "$SCRIPT"
  assert_success
}
