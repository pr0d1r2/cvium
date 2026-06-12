#!/usr/bin/env bash
set -euo pipefail
nix build
test -e result
