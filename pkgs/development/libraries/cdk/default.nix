{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cdk";
  version ="5.0-20190303";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "09dsim6yvsq0jlmb3diy30sx11y5zy6sn8kpymfvji4dk1q7ibdd";
  };

  meta = with stdenv.lib; {
    description = "Curses development kit";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
