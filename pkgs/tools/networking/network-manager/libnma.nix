{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig
, networkmanager, gtk3, gobject-introspection, gtk-doc
, docbook_xsl, docbook_xml_dtd_43, libxml2
, isocodes, mobile-broadband-provider-info
, withGnome ? true, gcr ? null
}:

stdenv.mkDerivation rec {
  pname = "libnma";
  version = "unstable-2019-11-04";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "fa19e6ee9820ab9a1ac0d39f6246c49d13e15e34";
    sha256 = "05d8fp1nfzvpc4na232yd4il8lyrwviirpmpilzqrg8hk3pg5r4h";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    gobject-introspection gtk-doc
    docbook_xsl docbook_xml_dtd_43 libxml2
  ];

  buildInputs = [
    gtk3 isocodes mobile-broadband-provider-info
  ] ++ stdenv.lib.optional withGnome gcr;

  propagatedBuildInputs = [ networkmanager ];

  mesonFlags = [
    "-Dgcr=${if withGnome then "true" else "false"}"
  ];

  # Needed for wingpanel-indicator-network and switchboard-plug-network
  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    substituteInPlace src/wireless-security/eap-method.c --subst-var-by NM_APPLET_GSETTINGS $lib/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';
}
