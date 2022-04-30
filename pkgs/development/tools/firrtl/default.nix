{ lib, stdenv, jre, coursier }:

# cs bootstrap edu.berkeley.cs::firrtl::1.5.3 -M firrtl.stage.FirrtlMain -o firrtl-1.5.3
let
  pname = "firrtl";
  version = "1.5.3";
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version;
    nativeBuildInputs = [ coursier ];
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      mkdir -p $out/bin
      cs bootstrap  edu.berkeley.cs::firrtl::${version} -M firrtl.stage.FirrtlMain -o $out/bin/${pname}-${version}
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-hpU13G1i4HkjWNiPgh8XBMn/sppv4iJxP++zHOZPhAQ=";
  };
in
  deps
#stdenv.mkDerivation {
#  inherit pname version;
#}
