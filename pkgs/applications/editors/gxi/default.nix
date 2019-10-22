{ stdenv, fetchurl, desktop-file-utils, gettext,
  meson, ninja, pkgconfig, rustc, cargo, wrapGAppsHook,
  cairo, glib, gtk3-x11, pango, libhandy, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "tau";
  version = "0.9.3";

  src = fetchurl {
    # XXX: yes, this URL needs replacing withe every version :(
    url = "https://gitlab.gnome.org/World/Tau/uploads/375ce054c0bc98e0c1a3e95fdcd4e46c/tau-0.9.3.tar.xz";
    sha256 = "02xfvav3hm7v33ai4dxhygl5a0rnd8m769q4c6kd2zgvhq7412z5";
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
