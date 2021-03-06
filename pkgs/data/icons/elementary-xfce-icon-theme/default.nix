{ stdenv, fetchFromGitHub, coreutils, pkgconfig, gdk-pixbuf, optipng, librsvg, gtk3, pantheon, gnome3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "elementary-xfce-icon-theme";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "v${version}";
    sha256 = "1f6qvpzxz759znishmr4b22n540y18glv41wmy91r78sa4g6x4sh";
  };

  nativeBuildInputs = [
    pkgconfig
    gdk-pixbuf
    librsvg
    optipng
    gtk3
  ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    gnome3.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ]; # glib 2.62.0

  postPatch = ''
    substituteInPlace svgtopng/Makefile --replace "-O0" "-O"
    substituteInPlace svgtopng/pngtheme.sh --replace bin/ls ${coreutils}/bin/ls

    for x in */index.theme; do
      echo "Fixing theme name for $x"
      echo "before: $(grep 'Name=' $x)"
      sed -i $x -e "s|Name=.*|Name=$(dirname $x)|"
      echo "after: $(grep 'Name=' $x)"
    done
  '';

  postInstall = ''
    make icon-caches
  '';

  meta = with stdenv.lib; {
    description = "Elementary icons for Xfce and other GTK desktops like GNOME";
    homepage = "https://github.com/shimmerproject/elementary-xfce";
    license = licenses.gpl2;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
