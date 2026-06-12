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
            packages = tools;
          };

          default = pkgs.mkShell {
            inputsFrom = [ ci ];
            packages = tools;
            shellHook = builtins.readFile ./nix/dev/shell.sh;
          };
        };
      }
    );
}
