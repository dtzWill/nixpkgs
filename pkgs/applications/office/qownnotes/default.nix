{  mkDerivation, lib, fetchurl, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwayland, qtwebsockets, stdenv /* for isLinux */ }:

mkDerivation rec {
  pname = "qownnotes";
  version = "19.8.5";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    # Can grab official version like so:
    # $ curl https://download.tuxfamily.org/qownnotes/src/qownnotes-19.1.8.tar.xz.sha256
    sha256 = "4210815ffbf20e7fe93b2c720dc363925afc53730f7de12612d24a27a7ab8c5f";
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
