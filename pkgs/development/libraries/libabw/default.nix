{ stdenv, fetchurl, boost, doxygen, gperf, pkgconfig, librevenge, libxml2, perl }:

stdenv.mkDerivation rec {
  name = "libabw-${version}";
  version = "0.1.3";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libabw/${name}.tar.xz";
    sha256 = "1vbfrmnvib3cym0yyyabnd8xpx4f7wp20vnn09s6dln347fajqz7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost doxygen gperf librevenge libxml2 perl ];

  meta = with stdenv.lib; {
    homepage = https://wiki.documentfoundation.org/DLP/Libraries/libabw;
    description = "Library parsing abiword documents";
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
