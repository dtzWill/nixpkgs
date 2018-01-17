{ stdenv
, fetch
, cmake
, zlib
, llvm
, python
, version
, llvm-config-dummy
, buildPackages
}:

let
  crossCompiling = stdenv.buildPlatform != stdenv.hostPlatform;
in stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "1v9nkpr158j4yd4zmi6rpnfxkp78r1fapr8wji9s6v176gji1kk3";

  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional crossCompiling  llvm-config-dummy;
  buildInputs = [ llvm ];

  cmakeFlags = stdenv.lib.optionals crossCompiling [
    "-DLLVM_CONFIG_PATH=${llvm-config-dummy}/bin/llvm-config"
    "-DLLVM_TABLEGEN_EXE=${buildPackages.llvm_4}/bin/llvm-tblgen"
  ];

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = http://lld.llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
