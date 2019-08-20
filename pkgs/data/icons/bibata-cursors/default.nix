{ fetchFromGitHub, gnome-themes-extra, inkscape, stdenv, xcursorgen }:

stdenv.mkDerivation rec {
  name = "bibata-cursors-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Cursor";
    #rev = "v${version}";
    rev = "765d0e77ece791fdf195a89bca12583d60a7b552";
    sha256 = "1jxj3vza48rdmvpg7kq7dsd15i7zfmca94p9lkqhfv12nzvxzxxz";
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
