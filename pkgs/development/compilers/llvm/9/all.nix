{ stdenv, fetchFromGitHub
, cmake, ninja
, python3, perl, which, swig
, libxml2, libffi, libbfd
, libedit
, ncurses, zlib
 }:

stdenv.mkDerivation rec {
  pname = "llvm-project";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-9.0.0";
    sha256 = "0zyl3if39pb96041wk3jg6fcqcx7hfiqdmr7w795vr68d529c22r";
  };

  nativeBuildInputs = [ cmake ninja python3 perl which swig ];

  buildInputs = [ libxml2 libffi libbfd libedit ];
  propagatedBuildInputs = [ ncurses zlib ];

  preConfigure = "cd llvm";

  cmakeFlags = [
    "-DLLVM_ENABLE_PROJECTS=all"
  ];
}
