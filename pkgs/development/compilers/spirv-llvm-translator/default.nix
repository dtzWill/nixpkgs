{ stdenv
, fetchFromGitHub
, cmake

, lit
, llvm_9
}:

stdenv.mkDerivation rec {
  pname = "SPIRV-LLVM-Translator";
  version = "9.0.0-1"; # XXX: looks like this should match llvm.version

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    rev = "v${version}";
    sha256 = "1a377v7y5nj1yap806fp6blxrra1m22prgyyzgsh40yf42z8r2wd";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ llvm_9 ];

  checkInputs = [ lit ];

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=ON" ];

  # FIXME: CMake tries to run "/llvm-lit" which of course doesn't exist
  doCheck = false;

  meta = with stdenv.lib; {
    homepage    = https://github.com/KhronosGroup/SPIRV-LLVM-Translator;
    description = "A tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    license     = licenses.ncsa;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming ];
  };
}
