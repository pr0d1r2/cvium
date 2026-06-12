#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/lint.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typstyle"

  PATH="$STUB:$PATH"
}

@test "succeeds when typstyle check passes" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when typstyle check reports issues" {
  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
echo "cv.typ is not formatted" >&2
exit 1
STUB
  chmod +x "$STUB/typstyle"

  run bash "$SCRIPT"
  assert_failure
}

@test "passes --check flag to typstyle" {
  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "--check" ]; then
    exit 0
  fi
done
echo "missing --check flag" >&2
exit 1
STUB
  chmod +x "$STUB/typstyle"

  run bash "$SCRIPT"
  assert_success
}
