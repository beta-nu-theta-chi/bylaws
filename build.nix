{ stdenv, buildenv, src, ... }:
stdenv.mkDerivation {
  pname = "BetaNuLBL";
  version = "0.0.1";

  inherit src;

  nativeBuildInputs = buildenv;

  buildPhase = ''
    python glossary.py

    cp branding/_brand-color.yml ./brand_light.yml
    cp branding/_brand-color_dark.yml ./brand_dark.yml
    export HOME=$(pwd)
    quarto render --no-cache
  '';

  installPhase = ''
    mkdir -p $out
    cp -r _book/* $out
  '';
}