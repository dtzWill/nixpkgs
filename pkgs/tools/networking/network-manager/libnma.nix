{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig
, networkmanager, gtk3, gobject-introspection, gtk-doc
, docbook_xsl, docbook_xml_dtd_43, libxml2
, isocodes, mobile-broadband-provider-info
, vala
, withGnome ? true, gcr ? null
}:

stdenv.mkDerivation rec {
  pname = "libnma";
  version = "unstable-2020-02-16";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "7f5f87992f0834dfda62e53174d601d954ef49be";
    sha256 = "1id6zfgspa7qixlb4n9z1ynlicgjqv6r678350f63l07wz4mmmzi";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    gobject-introspection gtk-doc
    docbook_xsl docbook_xml_dtd_43 libxml2
    vala
  ];

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [
    gtk3 isocodes mobile-broadband-provider-info
  ] ++ stdenv.lib.optional withGnome gcr;

  propagatedBuildInputs = [ networkmanager ];

  mesonFlags = [
    "-Dgcr=${if withGnome then "true" else "false"}"
  ];

  # Needed for wingpanel-indicator-network and switchboard-plug-network
  patches = [ ./hardcode-gsettings-ws.patch ];

  postPatch = ''
    substituteInPlace src/nma-ws/nma-eap.c --subst-var-by NM_APPLET_GSETTINGS $lib/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';
}
