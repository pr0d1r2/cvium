{
  description = "cvium — Marcin Nowicki's CV, built with Typst";

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
        lefthook = nix-lefthook.packages.${system}.default;
        batsWithLibs = pkgs.bats.withLibraries (p: [
          p.bats-support
          p.bats-assert
          p.bats-file
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            lefthook
            batsWithLibs
            pkgs.typst
            pkgs.typstyle
            pkgs.tinymist
            pkgs.git
            pkgs.just
            pkgs.shellcheck
            pkgs.shfmt
            pkgs.poppler-utils
            pkgs.gnugrep
            pkgs.gnused
            pkgs.findutils
            pkgs.coreutils
          ];
          BATS_LIB_PATH = "${batsWithLibs}/share/bats";
        };
      }
    );
}
