{ stdenv, fetchurl, cmake, pkgconfig, libGL, libwpe, wayland, glib }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.3.91";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1qhmn301xk8ayyq913pwlwpswpyx10wqshrhlryfhyq1al3nbd7b";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libGL libwpe wayland glib ];
}

