{ lib, stdenv, jre, setJavaClassPath, coursier, makeWrapper, writeTextFile }:

stdenv.mkDerivation rec {
  pname = "firrtl";
  version = "1.5.3";

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version;
    nativeBuildInputs = [ coursier ];
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

  nativeBuildInputs = [ makeWrapper setJavaClassPath ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-cp $CLASSPATH firrtl.stage.FirrtlMain"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = let
    testFile = writeTextFile {
      name = "test.fir";
      text = ''
        circuit test:
          module test:
            input a: UInt<8>
            input b: UInt<8>
            output o: UInt
            o <= add(a, not(b))
      '';
    }; in ''
    $out/bin/firrtl -i ${testFile} -o test.v
    cat test.v
  '';

  meta = with lib; {
    description = "Flexible Intermediate Representation for RTL";
    longDescription = ''
      Firrtl is an intermediate representation (IR) for digital circuits
      designed as a platform for writing circuit-level transformations.
    '';
    homepage = "https://www.chisel-lang.org/firrtl/";
    license = licenses.asl20;
    maintainers =  with maintainers; [ dtzWill ];
  };
}
