{ stdenv, fetchurl, alsaLib, fluidsynth, libjack2, qt5, autoconf, pkgconfig }:

mkDerivation  rec {
  pname = "qsynth";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/qsynth/${pname}-${version}.tar.gz";
    sha256 = "12jhfan81a10vbqfky5nmam3lk6d0i4654mm192v68q5r867xmcl";
  };

  nativeBuildInputs = [ autoconf pkgconfig ];

  buildInputs = [ alsaLib fluidsynth libjack2 qt5.qtbase qt5.qttools qt5.qtx11extras ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fluidsynth GUI";
    homepage = https://sourceforge.net/projects/qsynth;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
