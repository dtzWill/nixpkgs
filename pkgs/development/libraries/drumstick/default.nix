{ lib, mkDerivation, fetchurl, alsaLib, libpulseaudio, cmake, docbook_xsl, docbook_xml_dtd_45, doxygen
, fluidsynth, pkgconfig, qtbase, qtsvg
}:

mkDerivation rec {
  pname = "drumstick";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1n9wvg79yvkygrkc8xd8pgrd3d7hqmr7gh24dccf0px23lla9b3m";
  };

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_45 ];
  buildInputs = [
    alsaLib libpulseaudio doxygen fluidsynth qtbase qtsvg
  ];

  meta = with lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = http://drumstick.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
