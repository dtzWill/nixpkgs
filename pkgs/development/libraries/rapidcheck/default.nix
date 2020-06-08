{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rapidcheck";
  version = "unstable-2018-12-13";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = pname;
    rev   = "3eb9b4ff69f4ff2d9932e8f852c2b2a61d7c20d3";
    sha256 = "02qgdk8mlnlbipfrs310hbrqbgm3rdh2va1jz4w9m3is1g2pxs9y";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    cp ../extras/boost_test/include/rapidcheck/boost_test.h $out/include/rapidcheck
  '';

  meta = with stdenv.lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
