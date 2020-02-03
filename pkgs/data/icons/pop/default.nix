{ stdenv
, fetchFromGitHub
, meson
, ninja
, python3
, gtk3
, hicolor-icon-theme
}:

stdenv.mkDerivation {
  pname = "pop-icon-theme";
  version = "2020-01-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "icon-theme";
    rev = "34ed946cd6dcd3829c162afc43863976e9ddfae0";
    sha256 = "1yq8zaxd5dc9ndkfymiigcr0ljzh4k4p3f61cbi24rhdk27gvqb9";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    gtk3
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "System76 Pop Icon Theme";
    homepage = "https://github.com/pop-os/icon-theme";
    license = with licenses; [ gpl3 cc-by-sa-40 ];
    platforms = platforms.linux;

  };
}
