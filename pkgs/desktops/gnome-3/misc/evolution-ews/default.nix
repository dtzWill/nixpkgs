{ stdenv, cmake, ninja, intltool, fetchurl, libxml2, webkitgtk, highlight
, pkgconfig, gtk3, glib, libnotify, gtkspell3
, wrapGAppsHook, itstool, shared-mime-info, libical, db, gcr, sqlite
, gnome3, librsvg, gdk-pixbuf, libsecret, nss, nspr, icu
, libcanberra-gtk3, bogofilter, gst_all_1, procps, p11-kit, openldap
, libmspack
 }:

let
  pname = "evolution-ews";
  version = "3.32.2";
in stdenv.mkDerivation rec {
  inherit pname version;
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "10zx5v383iq66nrzmpvc7h8af1jxd26zjmcffsjk8y2a958q7s7z";
  };

  #propagatedUserEnvPkgs = [ gnome3.evolution-data-server gnome3.evolution ];

  buildInputs = [
    gtk3 glib gdk-pixbuf gnome3.defaultIconTheme librsvg db icu
    gnome3.evolution-data-server libsecret libical gcr
    webkitgtk shared-mime-info gnome3.gnome-desktop gtkspell3
    libcanberra-gtk3 bogofilter gnome3.libgdata sqlite
    gst_all_1.gstreamer gst_all_1.gst-plugins-base p11-kit
    nss nspr libnotify procps highlight gnome3.libgweather
    gnome3.gsettings-desktop-schemas
    gnome3.glib-networking openldap
    gnome3.evolution
    libmspack
  ];

  nativeBuildInputs = [ cmake ninja intltool itstool libxml2 pkgconfig wrapGAppsHook ];

  ## set env vars like "PKG_CONFIG_$PACKAGE_$VARIABLE"?

  # TODO:
  # - [ ] fix install paths
  # - [ ] ensure evolution and other bits actually find what is installed!
  # - [ ] meta

  #postPatch = ''
  #  sed -i CMakeLists.txt -e 's,set(ewsdatadir.*,set(ewsdatadir "${placeholder "out"}/share/evolution-data-dir/ews"),'
  #'';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution-ews";
      attrPath = "gnome3.evolution-ews";
    };
  };
}

