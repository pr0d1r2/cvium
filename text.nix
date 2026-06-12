{
  stdenvNoCC,
  typst,
  poppler_utils,
  rev ? "dev",
  src,
}:
stdenvNoCC.mkDerivation {
  pname = "cv-text";
  version = rev;
  inherit src;
  nativeBuildInputs = [
    typst
    poppler_utils
  ];
  env.REV = rev;
  dontConfigure = true;
  buildPhase = builtins.readFile ./nix/text/build.sh;
  installPhase = builtins.readFile ./nix/text/install.sh;
}
