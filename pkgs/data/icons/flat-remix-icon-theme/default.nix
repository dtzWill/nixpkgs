{ stdenv, fetchFromGitHub , gtk3 }:

stdenv.mkDerivation rec  {
  pname = "flat-remix-icon-theme";
  version = "20200116";

  src = fetchFromGitHub  {
    owner = "daniruiz";
    repo = "flat-remix";
    rev = version;
    sha256 = "14n5wydhd5ifmsbj770s2qg2ksd3xa3m61qxydid6jq39k0lxbd8";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Flat remix is a pretty simple icon theme inspired on material design";
    homepage = https://drasite.com/flat-remix;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
  };
}
 
