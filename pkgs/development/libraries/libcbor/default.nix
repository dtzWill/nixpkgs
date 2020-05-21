{ stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r6qag25nmjis9r3hwl3i57jwla4carvq7sfbwy74nq3gw1pq21h";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  NIX_CFLAGS_COMPILE = "-fno-lto";

  meta = with stdenv.lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = https://github.com/PJK/libcbor;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
