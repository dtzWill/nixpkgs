{ stdenv, fetchFromGitHub, coreutils, pkgconfig, gdk-pixbuf, optipng, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "elementary-xfce-icon-theme-${version}";
  version = "0.13.1.0.1"; # not really, git

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    #rev = "v${version}";
    rev = "8f5908fcc5a2907b335edbb76751ba2b7aa6e6e8";
    sha256 = "0p3x6pa42lylrazvb0k48aqv7ah8yc24bp3wqz2fkqfhfs524nnc";
  };

  nativeBuildInputs = [ pkgconfig gdk-pixbuf librsvg optipng gtk3 hicolor-icon-theme ];

  enableParallelBuilding = true;

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
    description = "Elementary icons for Xfce and other GTK+ desktops like GNOME";
    homepage = https://github.com/shimmerproject/elementary-xfce;
    license = licenses.gpl2;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
