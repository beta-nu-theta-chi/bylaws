{ stdenv, buildenv, ... }:
stdenv.mkDerivation {
  pname = "BetaNuLBL";
  version = "0.0.1";

  src = ./src;

  nativeBuildInputs = buildenv;

  buildPhase = ''
    export HOME=$(pwd)
    quarto render --no-cache
  '';

  installPhase = ''
    mkdir -p $out
    cp -r _book/* $out
  '';
}