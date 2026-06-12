#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/cachix-check.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  PATH="$STUB:$PATH"
}

@test "succeeds when cache has the derivation" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "eval" ] && [[ "$*" == *"builtins.currentSystem"* ]]; then
  printf "x86_64-linux"
  exit 0
fi
if [ "$1" = "eval" ] && [[ "$*" == *".#packages"* ]]; then
  printf "/nix/store/abc123-cvium"
  exit 0
fi
if [ "$1" = "path-info" ]; then
  exit 0
fi
exit 1
STUB
  chmod +x "$STUB/nix"

  run bash "$SCRIPT"
  assert_success
}

@test "fails when cache misses the derivation" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "eval" ] && [[ "$*" == *"builtins.currentSystem"* ]]; then
  printf "x86_64-linux"
  exit 0
fi
if [ "$1" = "eval" ] && [[ "$*" == *".#packages"* ]]; then
  printf "/nix/store/abc123-cvium"
  exit 0
fi
if [ "$1" = "path-info" ]; then
  echo "error: path not found" >&2
  exit 1
fi
exit 1
STUB
  chmod +x "$STUB/nix"

  run bash "$SCRIPT"
  assert_failure
}

@test "accepts system as first argument" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "eval" ] && [[ "$*" == *"aarch64-darwin"* ]]; then
  printf "/nix/store/def456-cvium"
  exit 0
fi
if [ "$1" = "path-info" ]; then
  exit 0
fi
echo "unexpected: $*" >&2
exit 1
STUB
  chmod +x "$STUB/nix"

  run bash "$SCRIPT" aarch64-darwin
  assert_success
}

@test "passes cache URL to nix path-info --store" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "eval" ] && [[ "$*" == *"builtins.currentSystem"* ]]; then
  printf "x86_64-linux"
  exit 0
fi
if [ "$1" = "eval" ] && [[ "$*" == *".#packages"* ]]; then
  printf "/nix/store/abc123-cvium"
  exit 0
fi
if [ "$1" = "path-info" ] && [ "$2" = "--store" ] && [ "$3" = "https://pr0d1r2.cachix.org" ]; then
  exit 0
fi
echo "unexpected: $*" >&2
exit 1
STUB
  chmod +x "$STUB/nix"

  run bash "$SCRIPT"
  assert_success
}

@test "skips currentSystem eval when system argument given" {
  cat >"$STUB/nix" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "eval" ] && [[ "$*" == *"builtins.currentSystem"* ]]; then
  echo "should not query currentSystem when argument given" >&2
  exit 1
fi
if [ "$1" = "eval" ] && [[ "$*" == *"x86_64-linux"* ]]; then
  printf "/nix/store/abc123-cvium"
  exit 0
fi
if [ "$1" = "path-info" ]; then
  exit 0
fi
echo "unexpected: $*" >&2
exit 1
STUB
  chmod +x "$STUB/nix"

  run bash "$SCRIPT" x86_64-linux
  assert_success
}
