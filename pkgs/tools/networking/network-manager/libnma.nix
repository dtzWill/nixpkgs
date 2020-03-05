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
  version = "unstable-2020-03-05";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "50cda26ae4beab31f30fb93fd36a7bcc5435adc1";
    sha256 = "19k0vbw4dnwnvmf8x8g48jybsldwaadnlmzg2zpqr4mjp4l8x23z";
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
