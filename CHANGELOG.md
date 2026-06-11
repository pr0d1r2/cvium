# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

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

- Typst CV source targeting Staff/L5 CI infrastructure roles
- Nix flake dev shell with typst, lefthook, just, bats, GNU tools
- justfile with build/watch/format/lint/test/text recipes
- scripts/ with no-function shell scripts
- .editorconfig, .yamllint.yml, .markdownlint.yml lint configs
- .envrc for direnv auto-activation
- .gitignore for nix/claude/result artifacts
- SPEC.md with 32 tasks, 28 invariants
- 65 agent skills from set-and-setting
