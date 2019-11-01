{ stdenv, fetchFromGitHub, pkgconfig, intltool, autoreconfHook, wrapGAppsHook
, gtk3, hicolor-icon-theme, netpbm, gspell, gtksourceview3
, withHTMLWidget ? false
, webkit2gtk ? null }:

stdenv.mkDerivation rec {
  pname = "yad";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "v1cont";
    repo = "yad";
    rev = "v${version}";
    sha256 = "07rd61hvilsxxrj7lf8c9k0a8glj07s48m7ya8d45030r90g3lvc";
  };

  configureFlags = [
    "--enable-icon-browser"
    "--with-rgb=${placeholder "out"}/share/yad/rgb.txt"
  ];

  buildInputs = [ gtk3 hicolor-icon-theme gspell gtksourceview3 ]
    ++ stdenv.lib.optional withHTMLWidget webkit2gtk;

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool wrapGAppsHook ];

  postPatch = ''
    # there is no point to bring in the whole netpbm package just for this file
    install -Dm644 ${netpbm}/share/netpbm/misc/rgb.txt $out/share/yad/rgb.txt
  '';

  postAutoreconf = ''
    intltoolize
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/yad-dialog/;
    description = "GUI dialog tool for shell scripts";
    longDescription = ''
      Yad (yet another dialog) is a GUI dialog tool for shell scripts. It is a
      fork of Zenity with many improvements, such as custom buttons, additional
      dialogs, pop-up menu in notification icon and more.
    '';

    license = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms = with platforms; linux;
  };
}
