#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/narrow-language-dictionaries.sh"
}

@test "succeeds when all dictionaries exist and are sorted" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cachix\ncvium\ntypst\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\ntypst\n' >"$DIR/.narrow-language-nix.dic"
  printf 'typst\n' >"$DIR/.narrow-language-other.dic"
  printf 'typst\n' >"$DIR/.narrow-language-shell.dic"
  run bash "$SCRIPT" "$DIR"
  assert_success
}

@test "fails when a dictionary is missing" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cachix\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-nix.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-other.dic"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "missing"
}

@test "fails when a dictionary is unsorted" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'typst\ncachix\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-nix.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-other.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-shell.dic"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "unsorted"
}

@test "fails when a dictionary has empty lines" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cachix\n\ntypst\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-nix.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-other.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-shell.dic"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "empty line"
}

@test "fails when a dictionary has duplicates" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cachix\ncachix\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-nix.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-other.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-shell.dic"
  run bash "$SCRIPT" "$DIR"
  assert_failure
  assert_output --partial "duplicates"
}

@test "defaults to current directory when no argument given" {
  DIR="$BATS_TEST_TMPDIR/repo"
  mkdir -p "$DIR"
  printf 'cachix\n' >"$DIR/.narrow-language-markdown.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-nix.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-other.dic"
  printf 'cachix\n' >"$DIR/.narrow-language-shell.dic"
  cd "$DIR"
  run bash "$SCRIPT"
  assert_success
}
