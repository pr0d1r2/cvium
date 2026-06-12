# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Changed

- 2-space indent is the editorconfig default everywhere unless overridden
- shfmt runs flagless to honor `.editorconfig` (upstream wrapper fix:
  pr0d1r2/nix-lefthook-shfmt#13)

### Fixed

- Consume nix-lefthook ci devShell via inputsFrom so hook wrappers
  resolve — local CI gate was non-functional (56 exit-127)
- Lean-trim lefthook.yml to the 16 bundle-backed remotes; defer the
  rest until their wrappers ship (SPEC §B B1, §T T52/T53)
- Correct typstyle check invocation (`--check`, not `check`)
- Stop text linters scanning binary/generated artifacts
  (cv.pdf, avatar.png, cv.txt, flake.lock)
- Format cv.typ with typstyle
- Blank lines around lists in skill docs (markdownlint MD032)

### Added

- QR code on CV linking to latest release (C12, V14)
- Bats test + script verifying QR code hyperlink present in PDF (V14)
- Git short rev embedded in PDF metadata via --input rev=SHORT_SHA (V15)
- Clickable hyperlinks in CV for email, GitHub, and LinkedIn (V12)
- Bats test + script verifying PDF contains hyperlink annotations (V12)
- Bats test + script verifying cv.pdf not stale vs cv.typ (V5 invariant)
- Bats test verifying typst compile succeeds with zero warnings (V1 invariant)
- Bats test + script verifying PDF page count = 2 (V2 invariant)
- `just photo <url>` — fetch a profile avatar (e.g. github.com/user),
  scale + optimize it, rebuild the CV, and commit on success
- Real GitHub avatar on the CV, pngquant-optimized
- Typst CV source targeting Staff/L5 CI infrastructure roles
- Nix flake dev shell with typst, lefthook, just, bats, GNU tools
- justfile with build/watch/format/lint/test/text recipes
- scripts/ with no-function shell scripts
- .editorconfig, .yamllint.yml, .markdownlint.yml lint configs
- .envrc for direnv auto-activation
- .gitignore for nix/claude/result artifacts
- SPEC.md with 32 tasks, 28 invariants
- 65 agent skills from set-and-setting
