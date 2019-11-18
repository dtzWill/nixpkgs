{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig, glib, python3, libgudev, libmbim
, gtk-doc, docbook_xsl, docbook_xml_dtd_43 }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  version = "1.24.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
    sha256 = "0yccw97pqn8afy96k5ssk7qi6r3wjshcnxk14k77qikkqa89zdmf";
  };

  outputs = [ "out" "dev" "devdoc" ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--enable-gtk-doc"
  ];

  nativeBuildInputs = [
    autoreconfHook # needed when building from git
    gtk-doc # needed to build docs, but w/releases pre-gen'd docs can be used
    docbook_xsl docbook_xml_dtd_43 # (also needed for building docs)
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
    libgudev
    libmbim
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/wiki/Software/libqmi;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
