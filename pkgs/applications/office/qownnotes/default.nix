{ stdenv, fetchurl, qmake, qttools, qtbase, qtsvg, qttranslations, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets }:

stdenv.mkDerivation rec {
  pname = "qownnotes";
  version = "19.5.2";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-19.1.8.tar.xz.sha256
    sha256 = "1578b965706d891c7a73424d3ad92ad1b7f4a48e3084874c0ef402bd153426fb";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [
    qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets
  ] ++ stdenv.lib.optional stdenv.isLinux qtwayland;

  meta = with stdenv.lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and ownCloud / Nextcloud integration";

    homepage = https://www.qownnotes.org/;
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
