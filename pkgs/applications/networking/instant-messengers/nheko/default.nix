{ lib, stdenv, fetchFromGitHub, fetchurl
, cmake, cmark, pkgconfig, lmdb, qt5, qtmacextras, mtxclient
, boost, spdlog, olm, nlohmann_json
}:

let
  tweeny = fetchFromGitHub {
    owner = "mobius3";
    repo = "tweeny";
    rev = "b94ce07cfb02a0eb8ac8aaf66137dabdaea857cf";
    sha256 = "1w381zf0k4cn8jxm492ib7mgr06ybjg2gbfak5map8ixixnsyjmp";
  };

  lmdbxx = fetchFromGitHub {
    owner = "bendiken";
    repo = "lmdbxx";
    rev = "0b43ca87d8cfabba392dfe884eb1edb83874de02";
    sha256 = "1whsc5cybf9rmgyaj6qjji03fv5jbgcgygp956s3835b9f9cjg1n";
  };
in
stdenv.mkDerivation rec {
  name = "nheko-${version}";
  version = "0.6.4";
  #version = "20190519.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    #rev = "v${version}";
    rev = "refs/tags/v${version}";
    sha256 = "19dkc98l1q4070v6mli4ybqn0ip0za607w39hjf0x8rqdxq45iwm";
  };

  # If, on Darwin, you encounter the error
  #   error: must specify at least one argument for '...' parameter of variadic
  #   macro [-Werror,-Wgnu-zero-variadic-macro-arguments]
  # Then adding this parameter is likely the fix you want.
  #
  # However, it looks like either cmake doesn't honor this CFLAGS variable, or
  # darwin's compiler doesn't have the same syntax as gcc for turning off
  # -Werror selectively.
  #
  # Anyway, this is something that will have to be debugged with access to a
  # darwin-based OS. Sorry about that!
  #
  #preConfigure = lib.optionalString stdenv.isDarwin ''
  #  export CFLAGS=-Wno-error=gnu-zero-variadic-macro-arguments
  #'';

  postPatch = ''
    mkdir -p .deps/include/
    ln -s ${tweeny}/include .deps/include/tweeny
    ln -s ${spdlog} .deps/spdlog
  '';

  cmakeFlags = [
    "-DTWEENY_INCLUDE_DIR=.deps/include"
    "-DLMDBXX_INCLUDE_DIR=${lmdbxx}"

    #"-DUSE_BUNDLED=OFF"

    ## mtxclient
    #"-DBoost_USE_STATIC_LIBS=OFF"
    #"-DBoost_USE_STATIC_RUNTIME=OFF"
    #"-DBoost_USE_MULTITHREADED=ON"
    #"-DCMAKE_CXX_STANDARD=14"
    #"-DCMAKE_CXX_STANDARD_REQUIRED=ON"
    #"-DCMAKE_POSITION_INDEPENDENT_CODE=ON"

    "-DUSE_BUNDLED_BOOST=OFF"
    #"-DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    mtxclient olm boost lmdb spdlog cmark nlohmann_json
    qt5.qtbase qt5.qtmultimedia qt5.qttools
  ] ++ lib.optional stdenv.isDarwin qtmacextras;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = https://github.com/Nheko-Reborn/nheko;
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
