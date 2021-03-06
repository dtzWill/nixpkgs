{ lib, stdenv, fetchurl, gtest, pkgconfig, doxygen, graphviz, cmake }:

stdenv.mkDerivation rec {
  name = "uriparser-${version}";
  version = "0.9.3";

  # Release tarball differs from source tarball
  src = fetchurl {
    url = "https://github.com/uriparser/uriparser/releases/download/${name}/${name}.tar.bz2";
    sha256 = "13z234jdaqs9jj7i66gcv4q1rgsypjz6cighnlm1j4g80pdlmbr8";
  };

  nativeBuildInputs = [ cmake pkgconfig doxygen graphviz ];
  buildInputs = lib.optional doCheck gtest;
  cmakeFlags = lib.optional (!doCheck) "-DURIPARSER_BUILD_TESTS=OFF";

  doCheck = false; # segfault

  meta = with stdenv.lib; {
    homepage = https://uriparser.github.io/;
    description = "Strictly RFC 3986 compliant URI parsing library";
    longDescription = ''
      uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C.
      API documentation is available on uriparser website.
    '';
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bosu ];
  };
}
