{ stdenv, fetchurl
, cmake, ninja
, python3, perl, which, swig
, libxml2, libffi, libbfd
, libedit
, ncurses, zlib
 }:

stdenv.mkDerivation rec {
  pname = "llvm-project";
  version = "9.0.1";

  src = fetchurl {
    url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/llvm-project-${version}.tar.xz";
    sha256 = "16s8g2s2571g8vmnspwan82a9amw40g2g9ciarhj974lgs01q97a";
  };

  nativeBuildInputs = [ cmake ninja python3 perl which swig ];

  buildInputs = [ libxml2 libffi libbfd libedit ];
  propagatedBuildInputs = [ ncurses zlib ];

  preConfigure = "cd llvm";

  cmakeFlags = [
    "-DLLVM_ENABLE_PROJECTS=all"
  ];
}
