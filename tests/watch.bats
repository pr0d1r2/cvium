#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/watch.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typst"

  PATH="$STUB:$PATH"
}

@test "succeeds when typst watch exits zero" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when typst watch exits non-zero" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
echo "error: file not found" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_failure
}

@test "passes --input rev=SHORT_SHA to typst watch" {
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
if [ "$1" != "watch" ]; then
  echo "expected watch subcommand" >&2
  exit 1
fi
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
