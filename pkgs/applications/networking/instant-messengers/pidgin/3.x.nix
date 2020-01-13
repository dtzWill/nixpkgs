{ stdenv, fetchFromBitbucket,
meson, ninja, pkgconfig,
glib,
gobject-introspection,
gtk3,
libX11,
libxml2,
json-glib,
libsoup,
libidn,
gst_all_1,
farstream,
avahi,
libsecret,
cyrus_sasl,
nettle,
talkatu,
gplugin,
libgnt
}:

stdenv.mkDerivation {
  pname = "pidgin";
  version = "unstable-2019-12-30";

  src = fetchFromBitbucket {
    owner = "pidgin";
    repo = "main";
    rev = "8066acc5ed93";
    sha256 = "0jwfrazdhva0v7pgfjfhry2rk4h2s81nbnkm3fh3202sq0vvjd02";
  };


  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [
    glib
    gtk3 libX11
    libxml2 json-glib libsoup
    libidn
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    farstream
    avahi
    libsecret
    cyrus_sasl
    nettle

    talkatu
    gplugin
    libgnt

    # kwallet
  ];

  mesonFlags = [
    "-Dfarstream=enabled"
    "-Dgstreamer=enabled"
    "-Dgstreamer-video=enabled"
    "-Dsecret-service=enabled"
    "-Dvv=enabled"
    "-Davahi=enabled"
    "-Didn=enabled"
    "-Dcyrus-sasl=enabled"

    # Disabled protocols
    "-Dmeanwhile=disabled"
    "-Dsilc=disabled"
    "-Dlibgadu=disabled"
    "-Dzephyr=disabled"

    # Disabled integrations
    "-Dunity-integration=disabled"
    "-Dkwallet=disabled"
  ];
  #meta = {
  #  description = "Pidgin 3.x (hg)";
  #};
}

