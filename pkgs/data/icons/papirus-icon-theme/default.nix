{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  name = "papirus-icon-theme";
  version = "20190516-git";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-icon-theme";
    #rev = version;
    rev = "e13a073b96b305c741bc3ca973c1696148f107ed";
    sha256 = "0hhkxwfdwpaxqnzwzlzpdlg5i48ddhx76jdflsqqvvprx6y3jix5";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
     mkdir -p $out/share/icons
     mv {,e}Papirus* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Papirus icon theme";
    homepage = https://github.com/PapirusDevelopmentTeam/papirus-icon-theme;
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
