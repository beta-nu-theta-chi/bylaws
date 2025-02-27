{ stdenv, buildenv, src, ... }:
stdenv.mkDerivation {
  pname = "BetaNuLBL";
  version = "0.0.1";

  inherit src;

  nativeBuildInputs = buildenv;

  buildPhase = ''
    cp branding/_brand-color.yml ./_brand.yml
    export HOME=$(pwd)
    quarto render --no-cache
  '';

  installPhase = ''
    mkdir -p $out
    cp -r _book/* $out
  '';
}