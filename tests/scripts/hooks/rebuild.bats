#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/scripts/hooks/rebuild.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/git" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "rev-parse" ] && [ "$2" = "--short" ] && [ "$3" = "HEAD" ]; then
  echo "abc1234"
  exit 0
fi
if [ "$1" = "add" ]; then
  exit 0
fi
exit 1
STUB

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB

  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB

  chmod +x "$STUB"/*
  PATH="$STUB:$PATH"

  cd "$BATS_TEST_TMPDIR" || return 1
  : >cv.typ
}

@test "compiles cv.typ and converts to text" {
  run bash "$SCRIPT"
  assert_success
}

@test "passes --input rev=SHORT_SHA to typst" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "rev=abc1234" ]; then
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

@test "stages cv.pdf and cv.txt" {
  cat >"$STUB/git" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "rev-parse" ]; then echo "abc1234"; exit 0; fi
if [ "$1" = "add" ]; then echo "$2" >>$BATS_TEST_TMPDIR/added.log; exit 0; fi
exit 1
STUB
  chmod +x "$STUB/git"

  run bash "$SCRIPT"
  assert_success
  run cat "$BATS_TEST_TMPDIR/added.log"
  assert_output --partial "cv.pdf"
  assert_output --partial "cv.txt"
}
