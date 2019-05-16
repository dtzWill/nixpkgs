{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, rapidjson, runtimeShell }:

stdenv.mkDerivation rec {
  name    = "ccls-${version}";
  #version = "0.20190329";
  version = "0.20190512";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    #rev = version;
    rev = "d3808de26ac00b36263aac73d8f64432472dff88";
    sha256 = "05j4zzpzvzcrw22288zvbpch4wfcsvf68szkn5cw05miczcqbsmh";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ all /* clang-unwrapped llvm */ rapidjson ];

  cmakeFlags = [
    #"-DLLVM_ENABLE_RTTI=ON"
    #"-DLLVM_LINK_LLVM_DYLIB=ON"
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12"
  ];

  shell = runtimeShell;
  postFixup = ''
    # We need to tell ccls where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${stdenv.lib.getDev stdenv.cc.libc}/include\\\""
    standard_library_includes+=", \\\"-isystem\\\", \\\"${llvmPackages.libcxx}/include/c++/v1\\\""
    export standard_library_includes

    wrapped=".ccls-wrapped"
    export wrapped

    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by clang";
    homepage    = https://github.com/MaskRay/ccls;
    license     = licenses.asl20;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.mic92 ];
  };
}
