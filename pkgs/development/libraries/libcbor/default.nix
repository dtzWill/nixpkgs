{ stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "unstable-2019-11-20";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "56a43b1e79993140b40617c630ce571907e3be0b";
    sha256 = "07v99kvwypm2hc9mqnfihz97pv0kfc3n6fnyy9c87fld47jp9dcl";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  NIX_CFLAGS_COMPILE = [ "-fno-lto" ];

  meta = with stdenv.lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = https://github.com/PJK/libcbor;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
