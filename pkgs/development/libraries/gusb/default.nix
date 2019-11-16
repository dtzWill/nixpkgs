{ stdenv, fetchurl, fetchFromGitHub, meson, ninja, pkgconfig, gettext, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44
, glib, systemd, libusb1, vala, hwdata
}:
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.3.1-git"; # git for recent fwupd usage

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "lib${pname}";
    rev = "13233c38eed954baf0ca3a95a23bd28ae02c8ba7";
    sha256 = "0jix7dnk8j19kkf932zi34b6fjgiadnsm1ygln3343vabl9jvw12";
  };
  #src = fetchurl {
  #  url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
  #  sha256 = "1p4f6jdjw6zl986f93gzdjg2hdcn5dlz6rcckcz4rbmnk47rbryq";
  #};

  nativeBuildInputs = [
    meson ninja pkgconfig gettext
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_44
    gobject-introspection vala
  ];
  buildInputs = [ systemd glib ];

  propagatedBuildInputs = [ libusb1 ];

  mesonFlags = [
    "-Dusb_ids=${hwdata}/share/hwdata/usb.ids"
  ];

  doCheck = false; # tests try to access USB

  meta = with stdenv.lib; {
    description = "GLib libusb wrapper";
    homepage = https://github.com/hughsie/libgusb;
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
