# Contributing

This repo is a personal CV and a demo of a spec-driven, agent-operated
build pipeline. Contributions to the **tooling** are welcome; the CV
content itself is the author's and not open for edits.

## Setup

Zero manual installs — [Nix](https://nixos.org/download) provides every
tool.

```bash
nix develop          # or: direnv allow  (auto-activates on cd)
just                 # list every command
```

Entering the shell installs the git hooks automatically.

## The loop

Work is spec-driven. `SPEC.md` holds the goal, constraints, invariants
(`§V`), and the task backlog (`§T`). The flow:

1. Pick an open `§T` task (status `.`).
2. Write the failing test first (TDD), then the implementation.
3. Commit per decision — small, topical commits with imperative
   messages.
4. Local hooks run the full suite on commit; fix until green.
5. Open a PR. Hosted CI runs the same suite and gates the merge.

Autonomous agents follow this exact loop against `SPEC.md`; the backlog
finishing itself is the demo.

## Rules

- **One linter per file type.** New tracked extension → add its linter
  to `lefthook.yml` before committing (`agent/set/skills/linter.md`).
- **No embedded shell** in `justfile`, `flake.nix`, or `lefthook.yml` —
  extract to `scripts/` and call `bash scripts/...`.
- **Every script has a 1-to-1 bats test** under `tests/`.
- **2-space indent** is the default (`.editorconfig`); shell follows it
  via `shfmt`.
- **CHANGELOG.md** gets a one-line entry per change.
- The behavioral rules live in `agent/set/skills/` — read them; they are
  the contract.

## Commits

Imperative mood, conventional style, one topic each:

```
feat(photo): just photo <url> — fetch, optimize, rebuild, commit
```

## Tests

```bash
just test            # run the bats suite
```
