#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  SCRIPT="$REPO/scripts/format.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typstyle"

  PATH="$STUB:$PATH"
}

@test "succeeds when typstyle exits zero" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when typstyle exits non-zero" {
  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
echo "error: formatting failed" >&2
exit 1
STUB
  chmod +x "$STUB/typstyle"

  run bash "$SCRIPT"
  assert_failure
}

@test "passes -i flag to typstyle" {
  cat >"$STUB/typstyle" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "-i" ]; then
    exit 0
  fi
done
echo "missing -i flag" >&2
exit 1
STUB
  chmod +x "$STUB/typstyle"

  run bash "$SCRIPT"
  assert_success
}
