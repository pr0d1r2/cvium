#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." && pwd)"
  SCRIPT="$REPO/nix/package/build.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typst"

  PATH="$STUB:$PATH"
  export REV="abc1234"
}

@test "compiles cv.typ to cv.pdf" {
  run bash "$SCRIPT"
  assert_success
}

@test "passes --input rev=REV to typst" {
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

@test "fails when typst compile fails" {
  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
echo "error: file not found" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_failure
}
