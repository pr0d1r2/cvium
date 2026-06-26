#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/pdf-not-stale.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/git" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "rev-parse" ] && [ "$2" = "--short" ] && [ "$3" = "HEAD" ]; then
  echo "abc1234"
  exit 0
fi
exit 1
STUB
  chmod +x "$STUB/git"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
printf "fresh" >"$5"
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

@test "passes --input rev=SHORT_SHA to typst" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "rev=abc1234" ]; then
    printf "fresh" >"$5"
    exit 0
  fi
done
echo "missing --input rev=abc1234" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_success
}
