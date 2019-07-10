{ stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "ganv-unstable-${rev}";
  rev = "2019-04-13";

  src = fetchgit {
    url = "http://git.drobilla.net/cgit.cgi/ganv.git";
    rev = "c4e5940f935b1ac4b152aa7a1311012791f073ae";
    sha256 = "1736skyy0p1chfycpx96k4w1dyx545wcc15z68gwzvhnbns0hxgw";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ graphviz gtk2 gtkmm2 python ];

  meta = with stdenv.lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = http://drobilla.net;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
