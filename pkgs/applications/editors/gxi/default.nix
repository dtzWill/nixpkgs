{ stdenv, fetchurl, desktop-file-utils, gettext,
  meson, ninja, pkgconfig, rustc, cargo, wrapGAppsHook,
  cairo, glib, gtk3-x11, pango, libhandy, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "tau";
  version = "0.10.2";

  src = fetchurl {
    # XXX: yes, this URL needs replacing with every version :(
    url = "https://gitlab.gnome.org/World/Tau/uploads/d7d7fc22a851466768edeace0f3d6b1b/tau-0.10.2.tar.xz";
    sha256 = "1cq6aah599spvs7qy9x88x7aliz63cxk2lk1n37i244d8ms1cm8l";
  };

  nativeBuildInputs = [
    meson ninja rustc cargo pkgconfig glib.dev
    gettext desktop-file-utils wrapGAppsHook
  ];
  buildInputs = [ stdenv cairo glib gtk3-x11 pango libhandy hicolor-icon-theme ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GTK frontend for the xi text editor, written in Rust";
    homepage = https://gitlab.gnome.org/World/Tau;
    license = licenses.mit;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
