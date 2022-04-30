{ lib, stdenv, jre, jdk, coursier, makeWrapper }:

# cs bootstrap edu.berkeley.cs::firrtl::1.5.3 -M firrtl.stage.FirrtlMain -o firrtl-1.5.3
let
  pname = "firrtl";
  version = "1.5.3";
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version;
    nativeBuildInputs = [ coursier ];
    ## TODO: Pin to 2.13?
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      cs fetch edu.berkeley.cs::${pname}::${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-xy3zdJZk6Q2HbEn5tRQ9Z0AjyXEteXepoWDaATjiUUw=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-cp $CLASSPATH firrtl.stage.FirrtlMain"

    runHook postInstall
  '';
}
