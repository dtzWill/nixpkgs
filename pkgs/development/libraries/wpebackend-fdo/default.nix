{ stdenv, fetchurl, cmake, pkgconfig, libGL, libwpe, wayland, glib }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.4.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1bwbs47v4nlzhsqrw9fpyny5m3n9ry0kfzsvk90zjif4bd5cl6d9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libGL libwpe wayland glib ];

  meta.broken = true; # XXX: mesa header update, EGL symbol snafu
}

