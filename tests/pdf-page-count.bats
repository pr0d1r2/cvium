#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/pdf-page-count.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/pdfinfo" <<'STUB'
#!/usr/bin/env bash
echo "Pages:          2"
STUB
  chmod +x "$STUB/pdfinfo"

  PATH="$STUB:$PATH"
}

@test "passes when PDF has 2 pages" {
  run bash "$SCRIPT"
  assert_success
}

@test "fails when PDF has 3 pages" {
  cat >"$STUB/pdfinfo" <<'STUB'
#!/usr/bin/env bash
echo "Pages:          3"
STUB
  chmod +x "$STUB/pdfinfo"

  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "expected 2 pages"
}

@test "fails when PDF has 1 page" {
  cat >"$STUB/pdfinfo" <<'STUB'
#!/usr/bin/env bash
echo "Pages:          1"
STUB
  chmod +x "$STUB/pdfinfo"

  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "expected 2 pages"
}
