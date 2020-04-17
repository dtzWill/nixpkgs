{ stdenv, fetchFromGitHub, meson, ninja, gtk3, python3, gnome3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "paper-icon-theme";
  version = "2019-05-25";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    rev = "ab51c46f2b562e0860eef0c2b2d673fd9811acdd";
    sha256 = "1351mia03k6yfgdlh42476m8xdjn7v8imnxvha20c4cks7pbr5ki";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    python3
  ];

  propagatedBuildInputs = [
    gnome3.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  postInstall = ''
    # The cache for Paper-Mono-Dark is missing
    gtk-update-icon-cache "$out"/share/icons/Paper-Mono-Dark;
  '';

  meta = with stdenv.lib; {
    description = "Modern icon theme designed around bold colours and simple geometric shapes";
    homepage = https://snwh.org/paper;
    license = with licenses; [ cc-by-sa-40 lgpl3 ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
