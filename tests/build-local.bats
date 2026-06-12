#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert

  REPO="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  SCRIPT="$REPO/scripts/build-local.sh"

  STUB="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$STUB"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
exit 0
STUB
  chmod +x "$STUB/typst"

  cat >"$STUB/git" <<'STUB'
#!/usr/bin/env bash
if [ "$1" = "rev-parse" ] && [ "$2" = "--short" ] && [ "$3" = "HEAD" ]; then
  echo "abc1234"
  exit 0
fi
exit 1
STUB
  chmod +x "$STUB/git"

  PATH="$STUB:$PATH"

  cd "$BATS_TEST_TMPDIR" || return
}

@test "fails when cv.local.typ is missing" {
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "cv.local.typ not found"
}

@test "fails when cv.local.typ has no phone line" {
  echo "// no phone here" >"$BATS_TEST_TMPDIR/cv.local.typ"

  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "no phone found"
}

@test "succeeds when cv.local.typ has phone and typst exits zero" {
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

  run bash "$SCRIPT"
  assert_success
}

@test "passes --input phone=VALUE to typst" {
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "phone=+48 123 456 789" ]; then
    exit 0
  fi
done
echo "missing --input phone" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_success
}

@test "passes --input rev=SHORT_SHA to typst" {
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

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

@test "outputs to cv.local.pdf" {
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

  cat >"$STUB/typst" <<'STUB'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "cv.local.pdf" ]; then
    exit 0
  fi
done
echo "missing cv.local.pdf output path" >&2
exit 1
STUB
  chmod +x "$STUB/typst"

  run bash "$SCRIPT"
  assert_success
}

@test "fails when typst compile exits non-zero" {
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

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
  echo '#let phone = "+48 123 456 789"' >"$BATS_TEST_TMPDIR/cv.local.typ"

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
