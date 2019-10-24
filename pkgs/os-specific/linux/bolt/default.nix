{ stdenv, meson, ninja, pkgconfig, fetchFromGitLab,
  python3, umockdev, gobject-introspection, dbus,
  asciidoc, libxml2, libxslt, docbook_xml_dtd_45, docbook_xsl,
  glib, systemd, polkit
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  version = "0.8-git";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "bolt";
    repo = "bolt";
    #rev = "${version}";
    rev = "7259ecdc4b93b27a0cb319b3c8bdbd7615b44616";
    sha256 = "0bklgjhlcdgyf7kjiq0m2i99lhmgarhih5ab71idbz0i10d1ck44";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    asciidoc libxml2 libxslt docbook_xml_dtd_45 docbook_xsl
  ] ++ stdenv.lib.optional (!doCheck) python3;

  buildInputs = [
    glib systemd polkit
  ];

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=${umockdev.out}/lib/
  '';

  checkInputs = [
    dbus umockdev gobject-introspection
    (python3.withPackages
      (p: [ p.pygobject3 p.dbus-python p.python-dbusmock ]))
  ];

  # meson install tries to create /var/lib/boltd
  patches = [ ./0001-skip-mkdir.patch ];

  postPatch = ''
    patchShebangs scripts tests
  '';

  mesonFlags = [
    "-Dlocalstatedir=/var"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  meta = with stdenv.lib; {
    description = "Thunderbolt 3 device management daemon";
    homepage = https://gitlab.freedesktop.org/bolt/bolt;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.callahad ];
    platforms = platforms.linux;
  };
}
