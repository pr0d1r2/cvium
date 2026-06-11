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
          pkgs.gnugrep
          pkgs.gnused
          pkgs.findutils
          pkgs.coreutils
        ];
      in
      {
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
