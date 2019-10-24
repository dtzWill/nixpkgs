{ stdenv, fetchurl, cmake, pkgconfig, libxkbcommon, libGL, xorg }:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.4.0.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "16wfpnvv02m0iq51z7hpn9vyc8ngf64i73ii9zrm8ww76kxrv109";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libGL ];
  propagatedBuildInputs = [ libxkbcommon xorg.libX11 ];
}
