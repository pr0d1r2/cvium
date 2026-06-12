#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/nix-build.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
touch result
exit 0
STUB
  chmod +x "$STUB/nix"

  PATH="$STUB:$PATH"
}

@test "succeeds when nix build produces result" {
  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
}

@test "passes build subcommand to nix" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "build" ]; then
  touch result
  exit 0
fi
echo "expected 'build' subcommand, got '$1'" >&2
exit 1
STUB
  chmod +x "$STUB/nix"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_success
}

@test "fails when nix build fails" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
echo "error: build failed" >&2
exit 1
STUB
  chmod +x "$STUB/nix"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}

@test "fails when result missing after build" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/nix"

  cd "$BATS_TEST_TMPDIR"
  run bash "$SCRIPT"
  assert_failure
}
