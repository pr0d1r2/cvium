# Security Policy

## Reporting a vulnerability

Email **<marcin@prodix.pl>** with the details. Use the subject line
`SECURITY: cvium`. Expect an acknowledgement within a few days.

Please do not open a public issue for a security problem until it has
been addressed.

## Scope

This repository builds a personal CV. The security surface is small:

- **Build/CI supply chain** — flake inputs, pinned GitHub Actions, the
  lefthook hook remotes.
- **Secrets** — none are tracked. `CACHIX_AUTH_TOKEN` lives only as a
  GitHub Actions secret, never in the repo.
- **Personal data** — the CV intentionally publishes the author's name,
  email, and links. The phone number is excluded by design (see
  `HARDENING.md`).

## What is not in scope

- The résumé content itself (it is public by intent).
- Typst, Nix, or nixpkgs upstream issues — report those to their
  respective projects.
