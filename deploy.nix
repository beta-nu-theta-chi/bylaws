{ src, stdenv, ... }:
stdenv.mkDerivation {
  inherit src;
  name = "GH-Action-builder";
  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/pdf
    mkdir -p $out/site
    mv *.pdf $out/pdf
    mv * $out/site
  '';
}