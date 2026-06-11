# Attribution

External software, services, and sources this project depends on.

## Build and document tooling

| Tool | Role | License |
| ---- | ---- | ------- |
| [Typst](https://typst.app) | CV typesetting | Apache-2.0 |
| [Nix / nixpkgs](https://nixos.org) | reproducible dev environment | MIT (nixpkgs) |
| [just](https://github.com/casey/just) | task runner | CC0-1.0 |
| [lefthook](https://github.com/evilmartians/lefthook) | git hook manager | MIT |
| [bats-core](https://github.com/bats-core/bats-core) | shell test runner | MIT |
| [shellcheck](https://www.shellcheck.net) / [shfmt](https://github.com/mvdan/sh) | shell lint/format | GPL-3.0 / BSD-3 |
| [poppler](https://poppler.freedesktop.org) | `pdftotext`, `pdftoppm` | GPL-2.0 |
| [ImageMagick](https://imagemagick.org) / [pngquant](https://pngquant.org) | avatar scale + optimize | ImageMagick / GPL |

All tooling is pulled through nixpkgs; per-package licenses are tracked
there.

## Flake inputs

| Input | Source |
| ----- | ------ |
| `nixpkgs` | github:NixOS/nixpkgs |
| `flake-utils` | github:numtide/flake-utils |
| `nix-lefthook` | github:pr0d1r2/nix-lefthook (bundled hook wrappers) |

## Services

| Service | Role |
| ------- | ---- |
| [GitHub Actions](https://github.com/features/actions) | hosted CI + releases |
| [Cachix](https://cachix.org) (`pr0d1r2`) | Nix binary cache |

## Conventions

The agent skills and the spec-driven workflow derive from the author's
`set-and-setting` rule set (`agent/set/skills/`).
