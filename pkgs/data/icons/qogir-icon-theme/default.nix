{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "2019-10-25";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "6ea7a5ef41971ea494a2665a22f15938e50eee16";
    sha256 = "0kzjwkjwal4rixz03vlzacidbhdayank6nqzwm2nrrz91wy1wi96";
  };

  nativeBuildInputs = [ gtk3 ];

  postPatch = ''
    # Remove mention of directory that doesn't exist.
    # GTK warns often about this otherwise.
    substituteInPlace src/index.theme \
      --replace "48/mimetypes," ""
  '';

  installPhase = ''
    patchShebangs install.sh
    mkdir -p $out/share/icons
    name= ./install.sh -d $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "A colorful design icon theme for linux desktops";
    homepage = https://github.com/vinceliuice/Qogir-icon-theme;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
