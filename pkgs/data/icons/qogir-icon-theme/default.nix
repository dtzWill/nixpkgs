{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "f9a8982ff17aac4f5e7d2ec0d8848db83894527f";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0m7f26dzzz5gkxi9dbbc96pl0xcvayr1ibxbjkrlsjcdvfg7p3rr";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;

  installPhase = ''
    patchShebangs install.sh
    mkdir -p $out/share/icons
    name= ./install.sh -d $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "A colorful design icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Qogir-icon-theme";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
