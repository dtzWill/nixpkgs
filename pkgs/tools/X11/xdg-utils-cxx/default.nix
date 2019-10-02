{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "xdg-utils-cxx";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "azubieta";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "00nvn00z1c7xvpb7xjm6i9i62hchg3nandxw487g6dallv378hw4";
  };

  nativeBuildInputs = [ cmake ];
}
