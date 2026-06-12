#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/text.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/pdftotext"

  PATH="$STUB:$PATH"
}

@test "succeeds when pdftotext exits zero" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when pdftotext exits non-zero" {
  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
echo "error: cv.pdf not found" >&2
exit 1
STUB
  chmod +x "$STUB/pdftotext"

  run bash "$SCRIPT"
  assert_failure
}

@test "passes -layout flag to pdftotext" {
  cat >"$STUB/pdftotext" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "-layout" ]; then
    exit 0
  fi
done
echo "missing -layout flag" >&2
exit 1
STUB
  chmod +x "$STUB/pdftotext"

  run bash "$SCRIPT"
  assert_success
}
