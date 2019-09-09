{  mkDerivation, lib, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets, stdenv /* for isLinux */ }:

mkDerivation rec {
  pname = "qownnotes";
  version = "19.9.5";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-19.1.8.tar.xz.sha256
    sha256 = "bad8fbb847d513fc3a8b7fcf841bf82b593162e11305cc2ac7ae45902eb06639";
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
