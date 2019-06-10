{ fetchFromGitHub, gnome-themes-extra, inkscape, stdenv, xcursorgen }:

stdenv.mkDerivation rec {
  name = "bibata-cursors-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Cursor";
    #rev = "v${version}";
    rev = "7c418db9c2a970a9ca06f6b5934de013549e3a5d";
    sha256 = "07h4h6gnqdjx7jqrbx4wzqhm233p731f7y2li2aphbx39gyclnkn";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace build.sh --replace "gksu " ""
  '';

  nativeBuildInputs  = [
    gnome-themes-extra
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    HOME="$NIX_BUILD_ROOT" ./build.sh
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr Bibata_* $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Material Based Cursor";
    homepage = https://github.com/KaizIqbal/Bibata_Cursor;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rawkode ];
  };
}
