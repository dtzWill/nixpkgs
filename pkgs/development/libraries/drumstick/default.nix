{ lib, mkDerivation, fetchurl, alsaLib, cmake, docbook_xsl, docbook_xml_dtd_45, doxygen
, fluidsynth, pkgconfig, qtbase, qtsvg
}:

mkDerivation rec {
  pname = "drumstick";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0kljqyqj7s1i2z52i24x7ail1bywn6dcxxfbad5c59drm8wv94bp";
  };

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig docbook_xsl docbook_xml_dtd_45 docbook_xml_dtd_45 ];
  buildInputs = [
    alsaLib doxygen fluidsynth qtbase qtsvg
  ];

  meta = with lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = http://drumstick.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
