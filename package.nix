{
  stdenvNoCC,
  typst,
  rev ? "dev",
  src,
}:
stdenvNoCC.mkDerivation {
  pname = "cv";
  version = rev;
  inherit src;
  nativeBuildInputs = [ typst ];
  env.REV = rev;
  dontConfigure = true;
  buildPhase = builtins.readFile ./nix/package/build.sh;
  installPhase = builtins.readFile ./nix/package/install.sh;
}
