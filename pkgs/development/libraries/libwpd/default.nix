{ stdenv, fetchurl, zlib, pkgconfig, glib, libgsf, libxml2, librevenge, boost }:

stdenv.mkDerivation rec {
  pname = "libwpd";
  version = "0.10.3";
  
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.xz";
    sha256 = "02fx8bngslcj7i5g1gx2kiign4vp09wrmp5wpvix9igxcavb0r94";
  };
  
  buildInputs = [ glib libgsf libxml2 zlib librevenge boost ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "A library for importing and exporting WordPerfect documents";
    homepage = http://libwpd.sourceforge.net/;
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
