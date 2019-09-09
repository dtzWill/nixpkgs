{ stdenv, fetchurl, cmake, pkgconfig, libxkbcommon, libGL, xorg }:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.3.91";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0gzrk5kz01x3lhz9wyrfkwki61nkagi4ymafmnpczm80fw2yglil";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libxkbcommon libGL xorg.libX11 ];
}
