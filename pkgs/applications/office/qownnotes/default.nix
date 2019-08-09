{  mkDerivation, lib, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets, stdenv /* for isLinux */ }:

mkDerivation rec {
  pname = "qownnotes";
  version = "19.8.3";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-19.1.8.tar.xz.sha256
    sha256 = "032c5232c67931fca2489e4f1e689e4e0cd6a2b35f40c2674cb99b7d694bbb98";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [
    qtbase qtsvg qtdeclarative qtxmlpatterns qtwebsockets
  ] ++ lib.optional stdenv.isLinux qtwayland;

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and ownCloud / Nextcloud integration";

    homepage = https://www.qownnotes.org/;
    platforms = platforms.all;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
