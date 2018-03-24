{ stdenv, fetchurl, pkgconfig, intltool, gnused
, expat, acl, systemd, glib, libatasmart, polkit
, libxslt, docbook_xsl, utillinux, mdadm, libgudev
, gobjectIntrospection
}:

stdenv.mkDerivation rec {
  name = "udisks-2.7.6";

  src = fetchurl {
    url = "https://github.com/storaged-project/udisks/releases/download/${name}/${name}.tar.bz2";
    sha256 = "1zhndp2hxqh8kyy6kb7a6l4g9bx0mr7js66rpznd876ycf8a4bai";
  };

  outputs = [ "out" "man" "dev" ];

  patches = [ ./force-path.patch ];

  # FIXME remove /var/run/current-system/sw/* references
  # FIXME add references to parted, cryptsetup, etc (see the sources)
  postPatch =
    ''
      substituteInPlace src/main.c --replace \
        "@path@" \
        "${utillinux}/bin:${mdadm}/bin:/run/current-system/sw/bin"
      substituteInPlace data/80-udisks2.rules \
        --replace "/bin/sh" "${stdenv.shell}" \
        --replace "/sbin/mdadm" "${mdadm}/bin/mdadm" \
        --replace " sed " " ${gnused}/bin/sed "
    '';

  nativeBuildInputs = [ pkgconfig intltool gobjectIntrospection ];

  buildInputs = [ libxslt docbook_xsl libgudev expat acl systemd glib libatasmart polkit ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-udevdir=$(out)/lib/udev"
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(dev)/share/gir-1.0"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/udisks;
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = stdenv.lib.platforms.linux;
  };
}
