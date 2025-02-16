{ src, stdenv, ... }:
stdenv.mkDerivation {
  inherit src;
  pname = "GH-Action-builder";
  version = "0.0.1";
  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/pdf
    mkdir -p $out/site
    mv *.pdf $out/pdf
    mv * $out/site
  '';
}