{
  description = "cvium — Marcin Nowicki's CV, built with Typst";

  nixConfig = {
    extra-substituters = "https://pr0d1r2.cachix.org";
    extra-trusted-public-keys = "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-lefthook = {
      url = "github:pr0d1r2/nix-lefthook";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix-lefthook,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ci = nix-lefthook.devShells.${system}.ci;
        lh = nix-lefthook.packages.${system};
        rev = self.shortRev or self.dirtyShortRev or "dev";
        tools = [
          pkgs.typst
          pkgs.typstyle
          pkgs.tinymist
          pkgs.git
          pkgs.just
          pkgs.shellcheck
          pkgs.shfmt
          pkgs.poppler-utils
          pkgs.curl
          pkgs.imagemagick
          pkgs.pngquant
          pkgs.qrencode
          pkgs.gnugrep
          pkgs.gnused
          pkgs.findutils
          pkgs.coreutils
        ];
        extraHooks = [
          lh.lefthook-actionlint
          lh.lefthook-bats-failures-only
          lh.lefthook-changelog-touched
          lh.lefthook-commit-msg-lint
          lh.lefthook-file-size-check
          lh.lefthook-justfile-alphabetical
          lh.lefthook-justfile-no-embedded-shell
          lh.lefthook-linter-coverage-full
          lh.lefthook-narrow-language
          lh.lefthook-narrow-language-compact
          lh.lefthook-narrow-language-freeze
          lh.lefthook-nix-flake-eval
          lh.lefthook-no-shell-functions
          lh.lefthook-pre-rebase-merged-commits
          lh.lefthook-tdd-order-bats
          lh.lefthook-unicode-lint
          lh.lefthook-unit-coverage
        ];
      in
      {
        packages = {
          default = pkgs.callPackage ./package.nix {
            inherit rev;
            src = pkgs.lib.fileset.toSource {
              root = ./.;
              fileset = pkgs.lib.fileset.unions [
                ./cv.typ
                ./avatar.png
                ./qr.png
              ];
            };
          };

          text = pkgs.callPackage ./text.nix {
            inherit rev;
            poppler_utils = pkgs.poppler-utils;
            src = pkgs.lib.fileset.toSource {
              root = ./.;
              fileset = pkgs.lib.fileset.unions [
                ./cv.typ
                ./avatar.png
                ./qr.png
              ];
            };
          };
        };

        devShells = {
          ci = pkgs.mkShell {
            inputsFrom = [ ci ];
            packages = tools ++ extraHooks;
            LEFTHOOK_TDD_SRC_STRIP = "";
          };

          default = pkgs.mkShell {
            inputsFrom = [ ci ];
            packages = tools ++ extraHooks;
            LEFTHOOK_TDD_SRC_STRIP = "";
            shellHook = builtins.readFile ./nix/dev/shell.sh;
          };
        };
      }
    );
}
