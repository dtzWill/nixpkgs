{ stdenv, fetchurl, glib, udev, libgudev, polkit, ppp, gettext, pkgconfig
, libmbim, libqmi, systemd, vala, gobject-introspection, dbus }:

let pname = "ModemManager"; in
stdenv.mkDerivation rec {
  pname = "modem-manager";
  version = "1.10.4";

  package = "ModemManager";
  src = fetchurl {
    url = "https://www.freedesktop.org/software/${package}/${package}-${version}.tar.xz";
    sha256 = "0w6wdj9dh7zwhzl68775h1ni6zcgvss524dp17kph50zpas6nmgs";
  };

  nativeBuildInputs = [ vala gobject-introspection gettext pkgconfig ];

  buildInputs = [ glib udev libgudev polkit ppp libmbim libqmi systemd ];

  configureFlags = [
    "--with-polkit"
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
    "--with-dbus-sys-dir=${placeholder "out"}/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemd-suspend-resume"
    "--with-systemd-journal"
  ];

  preCheck = ''
    export G_TEST_DBUS_DAEMON="${dbus.daemon}/bin/dbus-daemon"
  '';

  doCheck = true;

  postInstall = ''
    # systemd in NixOS doesn't use `systemctl enable`, so we need to establish
    # aliases ourselves.
    ln -s $out/etc/systemd/system/ModemManager.service \
      $out/etc/systemd/system/dbus-org.freedesktop.ModemManager1.service
  '';

  meta = with stdenv.lib; {
    description = "WWAN modem manager, part of NetworkManager";
    homepage = https://www.freedesktop.org/wiki/Software/ModemManager/;
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
