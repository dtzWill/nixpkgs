{ lib, stdenv, fetchFromGitHub
, cmake, llvmPackages, rapidjson, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "ccls";
  version = "0.20220729";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = version;
    sha256 = "sha256-eSWgk6KdEyjDLPc27CsOCXDU7AKMoXNyzoA6dSwZ5TI=";
  };

  # Improve handling of large amounts of stack (e.g., template instantiation)
  patches = [ ./fix-stack-usage.patch ./use-clang-stack-size.patch ];

  nativeBuildInputs = [ cmake llvmPackages.llvm.dev ];
  buildInputs = with llvmPackages; [ libclang llvm rapidjson ];

  cmakeFlags = [ "-DCCLS_VERSION=${version}" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "project(ccls LANGUAGES CXX)" \
                "project(ccls LANGUAGES C CXX)"
  '';

  clang = llvmPackages.clang;
  shell = runtimeShell;

  postFixup = ''
    export wrapped=".ccls-wrapped"
    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with lib; {
    description = "A c/c++ language server powered by clang";
    homepage    = "https://github.com/MaskRay/ccls";
    license     = licenses.asl20;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mic92 tobim ];
  };
}
