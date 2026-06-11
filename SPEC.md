# SPEC — cvium

## §G Goal

Typst CV compiles to PDF, auto-rebuilds and stages on commit via lefthook, managed via justfile. Nix dev shell for reproducibility. Uses nix-lefthook ecosystem for standard checks.

## §C Constraints

- C1: Typst source only — no LaTeX, no HTML
- C2: Nix flake dev shell — no brew, no global installs
- C3: PDF committed to repo (people see it on GitHub)
- C4: 2-page max output
- C5: All tooling runs via `nix develop`
- C6: Lefthook for pre-commit hooks — nix-lefthook as base
- C7: justfile for all recipes — no embedded shell (scripts in `scripts/`)
- C8: Lefthook remotes for standard checks, local commands for project-specific hooks

## §I Interfaces

- I.cli.build: `just build` — compile cv.typ → cv.pdf
- I.cli.watch: `just watch` — typst watch for live dev
- I.cli.format: `just format` — typstyle format cv.typ
- I.cli.lint: `just lint` — typstyle check cv.typ
- I.cli.test: `just test` — run bats tests
- I.hook.pdf: pre-commit local — typst compile + git add cv.pdf
- I.hook.remote: pre-commit remotes — yamllint, trailing-whitespace, missing-final-newline, editorconfig-checker, nixfmt, statix, deadnix, nix-no-embedded-shell, nix-flake-check, shellcheck, shfmt, typos
- I.file.src: `cv.typ` — source
- I.file.out: `cv.pdf` — output (committed, auto-rebuilt)
- I.file.asset: `avatar.png` — photo
- I.file.flake: `flake.nix` — dev shell + nix-lefthook input
- I.file.hook: `lefthook.yml` — hook config
- I.file.just: `justfile` — recipes calling scripts/

## §V Invariants

- V1: `typst compile cv.typ cv.pdf` succeeds with zero warnings
- V2: output PDF is exactly 2 pages
- V3: `typstyle check cv.typ` passes (formatted)
- V4: `nix flake check` passes
- V5: cv.pdf in repo matches cv.typ (no stale PDF)
- V6: no embedded shell in justfile recipes
- V7: lefthook.yml present and valid YAML
- V8: all justfile scripts exist in scripts/ and are executable
- V9: lefthook install succeeds in dev shell
- V10: all pre-commit hooks pass on clean tree

## §T Tasks

| id | status | task | cites |
|----|--------|------|-------|
| T1 | . | add justfile with build/watch/format/lint/test recipes calling scripts/ | I.cli,C7 |
| T2 | . | create scripts/build.sh, scripts/watch.sh, scripts/format.sh, scripts/lint.sh | C7,V8 |
| T3 | . | add nix-lefthook input to flake.nix, add lefthook+just+bats+shellcheck+shfmt to dev shell | C6,V9 |
| T4 | . | add lefthook.yml with remotes (yamllint, trailing-whitespace, missing-final-newline, editorconfig-checker, nixfmt, statix, deadnix, nix-no-embedded-shell, nix-flake-check, shellcheck, shfmt, typos) | I.hook.remote,C8 |
| T5 | . | add local pre-commit hook: typst compile + git add cv.pdf | I.hook.pdf,V5 |
| T6 | . | add local pre-commit hook: typstyle check | V3 |
| T7 | . | add .editorconfig, .yamllint.yml, .markdownlint.yml | I.hook.remote |
| T8 | . | add bats test: PDF page count = 2 | V2 |
| T9 | . | add bats test: typst compile succeeds | V1 |
| T10 | . | add bats test: cv.pdf not stale vs cv.typ | V5 |
| T11 | . | add shellHook to flake.nix: lefthook install | V9 |
| T12 | . | add nix-lefthook-justfile-no-embedded-shell remote to lefthook | C7,V6 |

## §B Bugs

| id | date | cause | fix |
|----|------|-------|-----|
