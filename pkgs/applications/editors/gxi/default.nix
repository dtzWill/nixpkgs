{ stdenv, fetchurl, desktop-file-utils, gettext,
  meson, ninja, pkgconfig, rustc, cargo, wrapGAppsHook,
  cairo, glib, gtk3-x11, pango, libhandy, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "tau";
  version = "0.10.1";

  src = fetchurl {
    # XXX: yes, this URL needs replacing with every version :(
    url = "https://gitlab.gnome.org/World/Tau/uploads/25d33d736285ad451bc7b409aa01e957/tau-0.10.1.tar.xz";
    sha256 = "14fwc308lhd0gwkbavy2rk9a8n9dgh0qww6mp7v5z8z5h6288zp9";
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
