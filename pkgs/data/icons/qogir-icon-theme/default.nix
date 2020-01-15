{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "unstable-2020-01-05";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "31d55b742836de3bb9d9e4ef3f417349afa8bb75";
    sha256 = "1dnj2bq1vb7y84vr14pjprh884gnzg11g7jrkh7s176a4fpgi53h";
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
