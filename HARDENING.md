# Hardening

Active measures that keep this repository safe to publish, and the
decisions behind them.

## Personal data — contact tiers

The CV is public by design, so it carries the author's name, email, and
profile links. One field is treated differently.

- **Phone number — excluded.** A phone number in a public, permanent git
  history is durable spam/abuse bait. It was removed from `cv.typ` and
  scrubbed from the full history with `git-filter-repo` *before* the
  first push (the rewrite window only exists while there is no remote).
  See `SPEC.md` §B B2 / §V V32.
- **Email and links — kept.** These are channels the author already
  publishes and can manage.
- **Direct-send variant (planned).** A gitignored `cv.local.typ` overlay
  may inject the phone for PDFs sent directly to a recipient, never
  committed (`SPEC.md` §T T34–T37).

The invariant **V46** captures the lesson that produced B2: a spec or
doc must never embed the literal secret it tracks (the original
invariants quoted the phone digits as grep patterns and re-leaked them).

## Supply chain

- **Pinned everything.** Nix flake inputs are locked; GitHub Actions are
  pinned to full 40-character commit SHAs, never mutable tags.
- **Reproducible build.** Every tool comes from the Nix flake, so CI and
  local builds run the same closure (cached via Cachix).
- **Local CI first.** Lefthook runs the full lint/format/test suite as
  git hooks before anything reaches GitHub; hosted CI mirrors it.

## Secrets

- No credentials, keys, or tokens are tracked. `.gitignore` excludes
  `.claude/`, `result*`, and `.direnv/`.
- `CACHIX_AUTH_TOKEN` exists only as a GitHub Actions secret.
- `gitleaks` runs in the check suite to catch accidental secret commits.

## Deferred

- `cv.local.typ` direct-send overlay (`SPEC.md` §T T34–T37).
- Per-system binary-cache verification, `cachix-check.sh` (§T T50).
