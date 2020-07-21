{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, gobject-introspection, vala
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, gtk3, gnome3
, dbus, xvfb_run, libxml2, hicolor-icon-theme
}:

let
  pname = "libhandy";
  version = "0.84.0";
in stdenv.mkDerivation rec {
  inherit pname version;
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ak1yncnbq9gc2735mqns9vwz7whfin5f83kl0lxy77rjsgm6p60";
  };

  patches = [
    (fetchpatch {
      name = "dont-crash-if-avatar-icon-not-found.patch";
      url = "https://gitlab.gnome.org/GNOME/libhandy/-/commit/36b8b469ed0d487390f6ea6f5c8eb705b51a57bd.patch";
      sha256 = "0znmian0nq3k5gsdyb03cdhc0rfy9xbcfiy2pn46jzzl10shq1p9";
    })
    (fetchpatch {
      name = "add-avatar-default-symbolic.patch";
      url = "https://gitlab.gnome.org/GNOME/libhandy/-/commit/d84fad380cf81930e1fd602b488baf55732f1d9f.patch";
      sha256 = "1f31prh0kmxa69jpjam2irw3gvwicssjaa6qdbhf4vlbfawkqria";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gobject-introspection vala libxml2
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gnome3.gnome-desktop gtk3 gnome3.glade libxml2 ];
  checkInputs = [ dbus xvfb_run hicolor-icon-theme ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=enabled"
    "-Dintrospection=enabled"
  ];

  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "A library full of GTK widgets for mobile phones";
    homepage = https://source.puri.sm/Librem5/libhandy;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
