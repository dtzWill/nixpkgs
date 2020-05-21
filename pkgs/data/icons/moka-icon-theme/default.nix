{ stdenv, fetchFromGitHub, meson, ninja, gtk3, python3, faba-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "moka-icon-theme";
  version = "2019-05-29";
  #version = "5.4.0";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = pname;
    #rev = "v${version}";
    rev = "c0355ea31e5cfdb6b44d8108f602d66817546a09";
    sha256 = "0m4kfarkl94wdhsds2q1l9x5hfa9l3117l8j6j7qm7sf7yzr90c8";
  };

  nativeBuildInputs = [
    meson
    ninja
    gtk3
    python3
  ];

  propagatedBuildInputs = [
    faba-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "An icon theme designed with a minimal flat style using simple geometry and bright colours";
    homepage = https://snwh.org/moka;
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
