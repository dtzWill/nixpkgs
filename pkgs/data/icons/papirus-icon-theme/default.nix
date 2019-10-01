{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "a22ac355076f51de6210436d9b7b84a6ce9fe57d";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    sha256 = "0y9l6d3pbvg1swzv1i39i89v1w1m066ir4dhgasf9ffddbx90474";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

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
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
