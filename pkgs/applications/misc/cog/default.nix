{ stdenv, fetchurl, cmake, pkgconfig, webkitgtk, libwpe, wpebackend-fdo, glib }:

stdenv.mkDerivation rec {
  pname = "cog";
  version = "0.4.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "00zw0k4idpn7ksyn13hcv0n5h364b5pix6s118sbfd144d8kmhg9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libwpe wpebackend-fdo webkitgtk glib ];

  cmakeFlags = [
    "-DCOG_USE_WEBKITGTK=ON" # default is wpe-webkit
  ];
}
