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
- C17: (skill: opensource/personal-data) Public cv.typ has NO phone — phone in gitignored cv.local.typ overlay only (email + links stay public)
- C18: (skill: git) Phone scrubbed from full git history before first push — rewrite window open while no remote
- C19: (skill: opensource/licensing) Personal CV, not template — tooling MIT, cv.typ content not licensed for reuse
- C20: (skill: opensource/documentation) Required OSS root docs all present: README, CONTRIBUTING, HARDENING, ATTRIBUTION, SECURITY, CODE_OF_CONDUCT
- C21: (skill: nix/modularity) No embedded shell in flake.nix — shellHook extracted to nix/dev/shell.sh
- C22: (skill: test/bats-with-libraries) No manual BATS_LIB_PATH — withLibraries wrapper only
- C23: (skill: opensource/ci) Two devShells — ci (no shellHook) + default
- C24: (skill: opensource/repo-scaffold) flake nixConfig declares cachix cache + public key

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
- I.file.hardening: `HARDENING.md` — security posture + PII contact-tier decision
- I.file.attribution: `ATTRIBUTION.md` — typst, nixpkgs, nix-lefthook, set-and-setting
- I.file.security: `SECURITY.md` — vuln-report policy
- I.file.coc: `CODE_OF_CONDUCT.md` — Contributor Covenant
- I.file.contributing: `CONTRIBUTING.md` — setup, test, style, commits
- I.file.local: `cv.local.typ` — gitignored phone overlay (direct-send only)
- I.file.localexample: `cv.local.example.typ` — tracked placeholder phone
- I.cli.buildlocal: `just build-local` — full PDF with phone, never committed
- I.nix.shell: `nix/dev/shell.sh` — extracted shellHook
- I.file.gitleaks: `.gitleaks.toml` — gitleaks allowlist (remote: nix-lefthook-gitleaks)
- I.file.cachixcheck: `cachix-check.sh` — verify binary cache per system
- I.github.templates: `.github/ISSUE_TEMPLATE/`, `.github/PULL_REQUEST_TEMPLATE.md`

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
- V29: public cv.typ has no phone number (contact line is email + links only)
- V30: committed cv.pdf phone-free — pdftotext extract has no phone digits
- V31: committed cv.txt phone-free — text export has no phone digits
- V32: (skill: git) phone absent from full git history — a `git log --all -S` search for the phone digits returns no commits
- V33: cv.local.typ gitignored, never tracked
- V34: (skill: opensource/secrets) cv.local.example.typ tracked with placeholder phone
- V35: (skill: nix/modularity) no embedded shell in flake.nix — shellHook reads nix/dev/shell.sh
- V36: (skill: test/bats-with-libraries) no BATS_LIB_PATH assignment in flake.nix
- V37: (skill: opensource/ci) flake exposes devShells.ci and devShells.default
- V38: README has badge row + page-1 preview + content-license note
- V39: HARDENING.md documents PII contact-tier decision
- V40: (skill: opensource/attribution) ATTRIBUTION.md lists typst, nixpkgs, nix-lefthook, set-and-setting
- V41: SECURITY.md present with vuln-report policy
- V42: CODE_OF_CONDUCT.md present
- V43: (nix-lefthook-gitleaks) .gitleaks.toml present, gitleaks remote passes
- V44: cachix-check.sh verifies cache per system
- V45: (skill: lefthook/wrapper-flake-inputs) every git_url remote in lefthook.yml has matching wrapper in devShell — `lefthook run pre-commit --all-files` yields zero exit-127
- V46: (skill: opensource/personal-data) no tracked file embeds the literal secret it tracks — SPEC/docs reference secrets abstractly (no phone digits, keys, tokens in prose or grep patterns)

## §T Tasks

| id | status | task | cites |
|----|--------|------|-------|
| T1 | x | add justfile with build/watch/format/lint/test/text recipes calling scripts/ | I.cli,C7 |
| T2 | x | create scripts/build.sh, scripts/watch.sh, scripts/format.sh, scripts/lint.sh, scripts/text.sh | C7,V8 |
| T3 | x | add nix-lefthook input to flake.nix, add lefthook+just+bats+shellcheck+shfmt+poppler_utils+gnugrep+gnused+findutils+coreutils to dev shell | C6,V9 |
| T4 | x | add lefthook.yml with remotes for both pre-commit and pre-push (see T4 detail) | I.hook.remote,C6,C8 |
| T5 | x | add local pre-commit hook: typst compile + git add cv.pdf + generate cv.txt + git add cv.txt (with timeout) | I.hook.pdf,V5,V13 |
| T6 | x | add local pre-commit hook: typstyle check (with timeout) | V3 |
| T7 | x | (skill: opensource/repo-scaffold) add .editorconfig, .yamllint.yml, .markdownlint.yml (sync-setting candidates) | I.hook.remote |
| T8 | x | add bats test: PDF page count = 2 | V2 |
| T9 | x | add bats test: typst compile succeeds | V1 |
| T10 | x | add bats test: cv.pdf not stale vs cv.typ | V5 |
| T11 | x | (skill: lefthook) add shellHook to flake.nix: lefthook install | V9 |
| T12 | x | add CHANGELOG.md | I.file.changelog,V18,C13 |
| T13 | x | make all links in cv.typ clickable hyperlinks (email, GitHub, LinkedIn) | V12,C11 |
| T14 | x | add git rev to PDF metadata via --input rev=SHORT_SHA | V15 |
| T15 | x | add QR code to CV linking to github.com/pr0d1r2/cvium/releases/latest | V14,C12 |
| T16 | x | add nix package output: packages.default builds cv.pdf derivation | I.nix.build,V11,C9 |
| T17 | x | add nix package output: packages.text builds cv.txt derivation | I.nix.text |
| T18 | x | add plain text export script (PDF → txt via pdftotext or typst query) | I.cli.text,V13 |
| T19 | x | (skill: ci/ci, ci/full-commit-sha) add .github/workflows/build.yml — build on push, verify PDF matches, pin actions to full SHA | I.ci.build,V16,C10 |
| T20 | x | (skill: ci/cd) add .github/workflows/release.yml — on tag, create release with cv.pdf | I.ci.release,C10 |
| T21 | x | add README.md with PDF preview screenshot of page 1 | I.file.readme,V17 |
| T22 | x | add bats test: cv.txt not stale vs cv.typ | V13 |
| T23 | x | add bats test: nix build succeeds | V11 |
| T24 | x | add bats test: links in PDF are hyperlinks | V12 |
| T25 | x | add bats test: QR code present in PDF | V14 |
| T26 | x | add tests/build.bats, tests/watch.bats, tests/format.bats, tests/lint.bats, tests/text.bats (1-to-1) | V19,C14 |
| T27 | x | add narrow-language dictionary for CV domain terms | V22 |
| T28 | x | (skill: direnv) add .envrc with `use flake` and watch | C5 |
| T29 | x | (skill: opensource/licensing) add MIT LICENSE | C15 |
| T30 | x | (skill: opensource/repo-scaffold) add .gitattributes marking cv.pdf as binary/generated | V28 |
| T31 | x | (skill: opensource/documentation) add CONTRIBUTING.md | V17 |
| T32 | x | (skill: opensource/repo-scaffold) add .gitignore (nix, claude, result) | V28 |
| T33 | x | (skill: git, opensource/personal-data) git-filter-repo strip phone from history — replace-text on cv.typ/cv.txt/SPEC.md, path-remove cv.pdf from all history then regen clean (pdf phone is compressed, regex misses it); via nix-shell -p git-filter-repo; before first push | C18,V32 |
| T34 | x | add optional phone sys-input to cv.typ (absent → omit line) so cv.local overlay can inject it; phone removal itself done by T33 | C17,V29 |
| T35 | . | add cv.local.typ overlay (gitignored) + cv.local.example.typ placeholder | C17,V33,V34 |
| T36 | . | add just build-local + scripts/build-local.sh — full PDF with phone, uncommitted | C17,I.cli.buildlocal |
| T37 | . | gitignore cv.local.typ, cv.local.pdf | V33 |
| T38 | x | regen cv.pdf/cv.txt phone-free, verify pdftotext extract has no phone digits | V30,V31 |
| T39 | x | (skill: opensource/documentation) add README.md — personal scope, badge row, page-1 preview, content-license note | I.file.readme,V17,V38 |
| T40 | x | (skill: opensource/documentation) add HARDENING.md documenting PII contact-tier decision | I.file.hardening,V39 |
| T41 | x | (skill: opensource/attribution) add ATTRIBUTION.md | I.file.attribution,V40 |
| T42 | x | add SECURITY.md vuln-report policy | I.file.security,V41 |
| T43 | x | add CODE_OF_CONDUCT.md (Contributor Covenant) | I.file.coc,V42 |
| T44 | x | add .github/ISSUE_TEMPLATE + PULL_REQUEST_TEMPLATE.md | I.github.templates |
| T45 | x | (skill: nix/modularity, direnv) extract flake shellHook to nix/dev/shell.sh, add .envrc watch_file | C21,V35 |
| T46 | x | (skill: test/bats-with-libraries) drop manual BATS_LIB_PATH from flake.nix | C22,V36 |
| T47 | x | (skill: opensource/ci) add devShells.ci (no shellHook) | C23,V37 |
| T48 | x | (skill: opensource/repo-scaffold) add cachix nixConfig + public key to flake | C24 |
| T49 | x | (nix-lefthook-gitleaks) add .gitleaks.toml allowlist | V43 |
| T50 | . | (skill: opensource/repo-scaffold) add cachix-check.sh | V44 |
| T51 | x | (skill: opensource/licensing) add content-license note — tooling MIT, cv.typ content reserved | C19 |
| T52 | x | (skill: lefthook/wrapper-flake-inputs) fix flake.nix — inputsFrom nix-lefthook.devShells.ci instead of packages.default (recovers 16 wrappers) | V45,B1 |
| T53 | . | upstream pr0d1r2/nix-lefthook — expose wrappers as individual packages.lefthook-* (NOT fatten ci — bloats all consumers); keep ci lean; cvium then composes exact 34. Repos for all ~18 missing exist | V45,B1 |
| T54 | x | (strategy B) lean-trim lefthook.yml to 16 bundle-backed remotes (swap markdownlint→markdownlint-agentic); defer 18 to T52/T53; restore per-task as wrappers land | V45,B1 |
| T55 | x | shfmt now honors .editorconfig (2-space). Wrapper fix nix-lefthook-shfmt#13 merged, bundle re-pin nix-lefthook#10 merged; cvium flake.lock bumped, local override removed, shfmt remote restored | V45 |
| T56 | x | add `just photo <url>` — fetch github avatar, scale + pngquant-optimize, rebuild, commit on success; curl+imagemagick+pngquant in devShell; tests/photo.bats | I.cli,streamline |

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
| B1 | 2026-06-11 | flake.nix consumes nix-lefthook.packages.default (lefthook binary only), not devShells.ci → 0 wrappers on PATH; bundle ci shell also missing ~18 of 34 wrappers referenced in lefthook.yml → `lefthook run pre-commit --all-files` yields 56 exit-127. Local-CI gate non-functional; prior commits bypassed hooks | T52 (local inputsFrom), T53 (upstream bundle), V45 |
| B2 | 2026-06-11 | SPEC.md embedded the literal phone digits in V29-V32/T38 grep patterns, re-leaking the secret into git history; a scrub targeting only cv.* would leave the number in the spec and its history | reword invariants digit-free, scrub covered SPEC.md history (T33), V46 |
