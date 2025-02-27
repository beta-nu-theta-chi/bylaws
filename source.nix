{ stdenv, branding, ... }:
stdenv.mkDerivation {
  pname = "BetaNuLBL-source";
  version = "0.0.1";

  src = ./src;

  installPhase = ''
    mkdir -p $out/branding
    cp -r * .* $out
    cp -r ${branding}/* $out/branding
  '';
}