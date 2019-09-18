{ stdenv, fetchurl, cmake, pkgconfig, libxkbcommon, libGL, xorg }:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.4.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1221vs72zs87anrzhbm6pf8jnii7s6ms7mkzj6nlds9zqd7lklz2";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libGL ];
  propagatedBuildInputs = [ libxkbcommon xorg.libX11 ];
}
