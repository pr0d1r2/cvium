# SPEC — cvium

## §G Goal

Typst CV compiles to PDF + plain text. Auto-rebuilds on commit. Nix flake produces PDF as build output. GitHub Actions auto-build on push, attach PDF to releases.

## §C Constraints

- C1: Typst source only — no LaTeX, no HTML
- C2: (skill: nix/develop) Nix flake dev shell — no brew, no global installs
- C3: PDF and plain text committed to repo (people see them on GitHub)
- C4: 2-page max PDF output
- C5: (skill: nix/develop, streamline) All tooling runs via `nix develop`
- C6: (skill: lefthook) Lefthook for pre-commit and pre-push hooks — nix-lefthook remotes
- C7: (skill: just/modularity, sh) justfile for all recipes — no embedded shell (scripts in `scripts/`)
- C8: (skill: lefthook/modularity) Lefthook remotes for standard checks, local commands for project-specific hooks
- C9: `nix build` produces cv.pdf as derivation output
- C10: GitHub Actions build on push, attach PDF to tagged releases
- C11: All links in PDF are clickable hyperlinks
- C12: QR code on CV links to this repo's latest release PDF
- C13: (skill: product/product) CHANGELOG.md updated on every change
- C14: (skill: tdd) Every script in scripts/ has matching bats test in tests/
- C15: (skill: opensource/licensing) MIT licensed
- C16: (skill: opensource/personal-data) CV contains author PII by design — exception to no-PII rule

## §I Interfaces

- I.cli.build: `just build` — compile cv.typ → cv.pdf
- I.cli.watch: `just watch` — typst watch for live dev
- I.cli.format: `just format` — typstyle format cv.typ
- I.cli.lint: `just lint` — typstyle check cv.typ
- I.cli.test: `just test` — run bats tests
- I.cli.text: `just text` — generate plain text export cv.txt
- I.nix.build: `nix build` — produces cv.pdf as derivation
- I.nix.text: `nix build .#text` — produces cv.txt as derivation
- I.hook.pdf: pre-commit local — typst compile + git add cv.pdf + generate cv.txt + git add cv.txt
- I.hook.remote: pre-commit + pre-push remotes — see §T.T4 for full list
- I.ci.build: GitHub Actions — build PDF on push, verify matches committed
- I.ci.release: GitHub Actions — on tag push, create release with cv.pdf attached
- I.file.src: `cv.typ` — source
- I.file.out: `cv.pdf` — PDF output (committed, auto-rebuilt)
- I.file.txt: `cv.txt` — plain text export (committed, auto-rebuilt)
- I.file.asset: `avatar.png` — photo
- I.file.flake: `flake.nix` — dev shell + packages + nix-lefthook input
- I.file.hook: `lefthook.yml` — hook config
- I.file.just: `justfile` — recipes calling scripts/
- I.file.readme: `README.md` — with PDF preview screenshot
- I.file.ci: `.github/workflows/build.yml` — CI workflow
- I.file.changelog: `CHANGELOG.md` — tracks changes

## §V Invariants

- V1: `typst compile cv.typ cv.pdf` succeeds with zero warnings
- V2: output PDF is exactly 2 pages
- V3: `typstyle check cv.typ` passes (formatted)
- V4: (skill: lefthook/nix) `nix flake check` passes
- V5: cv.pdf in repo matches cv.typ (no stale PDF)
- V6: (skill: just/modularity) no embedded shell in justfile recipes
- V7: (skill: lefthook) lefthook.yml present and valid YAML
- V8: (skill: sh, just/modularity) all justfile scripts exist in scripts/ and are executable
- V9: (skill: lefthook) lefthook install succeeds in dev shell
- V10: (skill: lefthook) all pre-commit and pre-push hooks pass on clean tree
- V11: `nix build` succeeds and produces cv.pdf
- V12: all links in PDF are clickable (email, GitHub, LinkedIn)
- V13: cv.txt in repo matches cv.typ (no stale text)
- V14: QR code in PDF resolves to valid GitHub URL
- V15: git short rev embedded in PDF metadata
- V16: (skill: ci/ci) GitHub Actions build matches local build (reproducible)
- V17: README.md contains preview image of page 1
- V18: (skill: product/product) CHANGELOG.md touched on every commit with changes
- V19: (skill: tdd) every scripts/*.sh has matching tests/*.bats (1-to-1 coverage)
- V20: (nix-lefthook-file-size-check) cv.pdf size under 500KB
- V21: (nix-lefthook-nix-flake-lock-budget) flake.lock node count within budget
- V22: (nix-lefthook-unicode-lint) no invisible Unicode characters in source files
- V23: (skill: language/imperative) commit messages follow conventional format
- V24: (skill: linter) all files in repo covered by at least one linter
- V25: (skill: sh) no shell functions in scripts/*.sh
- V26: (skill: just) justfile recipes in alphabetical order
- V27: (nix-lefthook-pre-rebase-merged-commits) no merged commits on feature branches
- V28: (skill: opensource/repo-scaffold) .gitattributes marks generated files

## §T Tasks

| id | status | task | cites |
|----|--------|------|-------|
| T1 | . | add justfile with build/watch/format/lint/test/text recipes calling scripts/ | I.cli,C7 |
| T2 | . | create scripts/build.sh, scripts/watch.sh, scripts/format.sh, scripts/lint.sh, scripts/text.sh | C7,V8 |
| T3 | . | add nix-lefthook input to flake.nix, add lefthook+just+bats+shellcheck+shfmt+poppler_utils+gnugrep+gnused+findutils+coreutils to dev shell | C6,V9 |
| T4 | . | add lefthook.yml with remotes for both pre-commit and pre-push (see T4 detail) | I.hook.remote,C6,C8 |
| T5 | . | add local pre-commit hook: typst compile + git add cv.pdf + generate cv.txt + git add cv.txt (with timeout) | I.hook.pdf,V5,V13 |
| T6 | . | add local pre-commit hook: typstyle check (with timeout) | V3 |
| T7 | . | (skill: opensource/repo-scaffold) add .editorconfig, .yamllint.yml, .markdownlint.yml (sync-setting candidates) | I.hook.remote |
| T8 | . | add bats test: PDF page count = 2 | V2 |
| T9 | . | add bats test: typst compile succeeds | V1 |
| T10 | . | add bats test: cv.pdf not stale vs cv.typ | V5 |
| T11 | . | (skill: lefthook) add shellHook to flake.nix: lefthook install | V9 |
| T12 | . | add CHANGELOG.md | I.file.changelog,V18,C13 |
| T13 | . | make all links in cv.typ clickable hyperlinks (email, GitHub, LinkedIn) | V12,C11 |
| T14 | . | add git rev to PDF metadata via --input rev=SHORT_SHA | V15 |
| T15 | . | add QR code to CV linking to github.com/pr0d1r2/cvium/releases/latest | V14,C12 |
| T16 | . | add nix package output: packages.default builds cv.pdf derivation | I.nix.build,V11,C9 |
| T17 | . | add nix package output: packages.text builds cv.txt derivation | I.nix.text |
| T18 | . | add plain text export script (PDF → txt via pdftotext or typst query) | I.cli.text,V13 |
| T19 | . | (skill: ci/ci, ci/full-commit-sha) add .github/workflows/build.yml — build on push, verify PDF matches, pin actions to full SHA | I.ci.build,V16,C10 |
| T20 | . | (skill: ci/cd) add .github/workflows/release.yml — on tag, create release with cv.pdf | I.ci.release,C10 |
| T21 | . | add README.md with PDF preview screenshot of page 1 | I.file.readme,V17 |
| T22 | . | add bats test: cv.txt not stale vs cv.typ | V13 |
| T23 | . | add bats test: nix build succeeds | V11 |
| T24 | . | add bats test: links in PDF are hyperlinks | V12 |
| T25 | . | add bats test: QR code present in PDF | V14 |
| T26 | . | add tests/build.bats, tests/watch.bats, tests/format.bats, tests/lint.bats, tests/text.bats (1-to-1) | V19,C14 |
| T27 | . | add narrow-language dictionary for CV domain terms | V22 |
| T28 | . | (skill: direnv) add .envrc with `use flake` and watch | C5 |
| T29 | . | (skill: opensource/licensing) add MIT LICENSE | C15 |
| T30 | . | (skill: opensource/repo-scaffold) add .gitattributes marking cv.pdf as binary/generated | V28 |
| T31 | . | (skill: opensource/documentation) add CONTRIBUTING.md | V17 |
| T32 | x | (skill: opensource/repo-scaffold) add .gitignore (nix, claude, result) | V28 |

### T4 detail — lefthook remotes

All remotes configured for both pre-commit and pre-push per skill:lefthook.

**Nix checks:**
- `nix-lefthook-nixfmt` — format flake.nix
- `nix-lefthook-statix` — lint flake.nix
- `nix-lefthook-deadnix` — dead code in flake.nix
- `nix-lefthook-nix-no-embedded-shell` — no embedded shell in nix files
- `nix-lefthook-nix-flake-check` — nix flake check
- `nix-lefthook-nix-flake-eval` — evaluate flake attributes
- `nix-lefthook-nix-flake-lock-budget` — guard flake.lock size/node count

**Shell checks:**
- `nix-lefthook-shellcheck` — lint scripts/*.sh
- `nix-lefthook-shfmt` — format scripts/*.sh
- `nix-lefthook-no-shell-functions` — no functions in scripts/*.sh

**Justfile checks:**
- `nix-lefthook-justfile-no-embedded-shell` — enforce C7
- `nix-lefthook-justfile-alphabetical` — recipe order

**YAML/TOML/Markdown:**
- `nix-lefthook-yamllint` — lint YAML files
- `nix-lefthook-taplo` — lint TOML files (if any)
- `nix-lefthook-markdownlint` — lint README.md, SPEC.md, CHANGELOG.md

**Text hygiene:**
- `nix-lefthook-typos` — spell check all files
- `nix-lefthook-trailing-whitespace` — no trailing whitespace
- `nix-lefthook-missing-final-newline` — all files end with newline
- `nix-lefthook-unicode-lint` — catch invisible Unicode
- `nix-lefthook-narrow-language` — vocabulary checks for CV domain

**Git hygiene:**
- `nix-lefthook-git-conflict-markers` — no conflict markers
- `nix-lefthook-git-no-local-paths` — no hardcoded local paths
- `nix-lefthook-gitleaks` — no secrets in repo
- `nix-lefthook-commit-msg-lint` — enforce commit message format
- `nix-lefthook-pre-rebase-merged-commits` — no merged commits on branches

**File checks:**
- `nix-lefthook-editorconfig-checker` — enforce .editorconfig
- `nix-lefthook-file-size-check` — guard cv.pdf under 500KB
- `nix-lefthook-linter-coverage-full` — all files covered by linter
- `nix-lefthook-changelog-touched` — CHANGELOG.md touched on changes

**Bats checks:**
- `nix-lefthook-bats-parse` — validate bats syntax
- `nix-lefthook-bats-unit` — run bats tests on commit
- `nix-lefthook-bats-failures-only` — show only failures
- `nix-lefthook-tdd-order-bats` — enforce TDD test order
- `nix-lefthook-unit-coverage` — 1-to-1 scripts/ ↔ tests/ coverage

**GitHub Actions:**
- `nix-lefthook-actionlint` — lint .github/workflows/*.yml
- `nix-lefthook-ci-action` — composite action for Nix + lefthook CI

## §B Bugs

| id | date | cause | fix |
|----|------|-------|-----|
