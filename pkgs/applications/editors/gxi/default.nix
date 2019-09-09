{ stdenv, fetchurl, desktop-file-utils, gettext,
  meson, ninja, pkgconfig, rustc, cargo, wrapGAppsHook,
  cairo, glib, gtk3-x11, pango
}:

stdenv.mkDerivation rec {
  pname = "tau";
  version = "0.9.2";

  src = fetchurl {
    url = "https://gitlab.gnome.org/World/Tau/uploads/fdf09640e3837ad509f5c4b1da0c26e3/tau-0.9.2.tar.xz";
    sha256 = "07ahl1h72w9sggq1r24k4mlfn9hx5r90kvdlra170bgpdcsvg3g4";
  };

  nativeBuildInputs = [
    meson ninja rustc cargo pkgconfig
    gettext desktop-file-utils wrapGAppsHook
  ];
  buildInputs = [ stdenv cairo glib gtk3-x11 pango ];

  enableParallelBuilding = true;

  preConfigure = ''
    export DESTDIR=/
  '';

  meta = with stdenv.lib; {
    description = "GTK frontend for the xi text editor, written in Rust";
    homepage = https://gxi.cogitri.dev;
    license = licenses.mit;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
