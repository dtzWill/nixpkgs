{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, boost, openssl, zlib, libsodium, olm, gtest, spdlog, nlohmann_json }:

stdenv.mkDerivation rec {
  name = "mtxclient-${version}";
  version = "0.2.0-git";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    #rev = "v${version}";
    rev = "d5cc703848b44c1a9c543dc01355b7881f66ea81";
    sha256 = "1q2vxyjs9x6hq1g5qkzm6pfg1dj2zi1zx8zxb13kfgd6dkcv7z3d";
  };

  cmakeFlags = [
    "-DBUILD_LIB_TESTS=OFF" "-DBUILD_LIB_EXAMPLES=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost openssl nlohmann_json zlib libsodium olm ];

  meta = with stdenv.lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = https://github.com/mujx/mtxclient;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
