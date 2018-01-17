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

  src = fetch "lld" "15fq2zvkliyiw5qi7ig2r8bshgbz4kzvs5in16mhfkw20l06rcym";

  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional crossCompiling  llvm-config-dummy;
  buildInputs = [ llvm ];

  cmakeFlags = stdenv.lib.optionals crossCompiling [
    "-DLLVM_CONFIG_PATH=${llvm-config-dummy}/bin/llvm-config"
    "-DLLVM_TABLEGEN_EXE=${buildPackages.llvm_5}/bin/llvm-tblgen"
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
