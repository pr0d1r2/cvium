#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/pdf-not-stale.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
printf "fresh" >"$3"
STUB
  chmod +x "$STUB/typst"

  PATH="$STUB:$PATH"

  mkdir -p "$BATS_TEST_TMPDIR/work"
  : >"$BATS_TEST_TMPDIR/work/cv.typ"
  printf "fresh" >"$BATS_TEST_TMPDIR/work/cv.pdf"
  cd "$BATS_TEST_TMPDIR/work" || return 1
}

@test "passes when cv.pdf matches compiled output" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when cv.pdf differs from compiled output" {
  printf "stale" >"$BATS_TEST_TMPDIR/work/cv.pdf"
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "cv.pdf is stale"
}

@test "fails when cv.pdf is missing" {
  rm "$BATS_TEST_TMPDIR/work/cv.pdf"
  run bash "$SCRIPT"
  assert_failure
}
