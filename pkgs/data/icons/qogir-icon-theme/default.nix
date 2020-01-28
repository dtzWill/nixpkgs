{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "unstable-2020-01-27";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "db6995acf587ad16cb9a05767a762bc9666f05dd";
    sha256 = "0g6qiry4gzkr48xn4qi8sdna0hi3982sywskz9adkzqcznir542h";
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
