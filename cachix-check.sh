#!/usr/bin/env bash
set -euo pipefail

cache="https://pr0d1r2.cachix.org"
system="${1:-$(nix eval --impure --expr builtins.currentSystem --raw)}"

path=$(nix eval --raw ".#packages.${system}.default.outPath")
nix path-info --store "$cache" "$path" >/dev/null 2>&1
