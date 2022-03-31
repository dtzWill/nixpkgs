{ lib, stdenv, fetchFromGitHub
, cmake, llvmPackages, rapidjson, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "ccls";
  version = "unstable-2022-01-22";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = "790daca4b2d9d5873623fee86283cd61212df674";
    sha256 = "sha256-0HXHQd+D+Nfs65lKqly0aS0UkTbGUjWkUe3q9g77UQI=";
  };

  # Improve handling of large amounts of stack (e.g., template instantiation)
  patches = [ ./fix-stack-usage.patch ];

  nativeBuildInputs = [ cmake llvmPackages.llvm.dev ];
  buildInputs = with llvmPackages; [ libclang llvm rapidjson ];

  cmakeFlags = [ "-DCCLS_VERSION=${version}" "-DCMAKE_BUILD_TYPE=Debug" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  # Fix build w/recent Clang by adding 'C' to LANGUAGES
  # TODO: replace this with upstream commit!
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "project(ccls LANGUAGES CXX)" \
                "project(ccls LANGUAGES C CXX)"
    
    # Bump default thread stack size
    substituteInPlace src/platform_posix.cc \
      --replace 'size_t stack_size = 4 * 1024 * 1024;' \
                'size_t stack_size = 10 * 1024 * 1024;'

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
