{ src, stdenv, gnutar, ... }:
stdenv.mkDerivation {
  inherit src;
  pname = "GH-Action-builder";
  version = "0.0.1";
  nativeBuildInputs = [ gnutar ];

  installPhase = ''
    mkdir -p $out/pdf
    mv *.pdf $out/pdf
    tar -czf $out/site.tar.gz *
  '';
}