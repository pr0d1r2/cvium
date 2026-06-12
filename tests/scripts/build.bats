#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/build.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typst"

  PATH="$STUB:$PATH"
}

@test "succeeds when typst compile exits zero with no warnings" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when typst compile exits non-zero" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
echo "error: file not found" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_failure
}

@test "fails when typst emits a warning on stderr" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
echo "warning: unused variable" >&2
exit 0
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "warning"
}

@test "passes --input rev=SHORT_SHA to typst" {
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
