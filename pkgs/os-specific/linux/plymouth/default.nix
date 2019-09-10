{ stdenv, fetchurl, fetchgit, autoreconfHook, intltool, pkgconfig, libxslt, docbook_xsl
, gtk3, udev, systemd
}:

stdenv.mkDerivation rec {
  pname = "plymouth";
  #version = "0.9.4";
  version = "2019-09-09";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/plymouth/plymouth.git";
    rev = "c97d52e2ade82b416e50c532630f5c6a8f303ab3";
    sha256 = "1iv03ny71gnvws0jwk6ll9ndg1xh61q765ngfjphgz6iwbs59pdw";
  };
  #src = fetchurl {
  #  url = "https://www.freedesktop.org/software/plymouth/releases/${name}.tar.xz";
  #  sha256 = "0l8kg7b2vfxgz9gnrn0v2w4jvysj2cirp0nxads5sy05397pl6aa";
  #};

  nativeBuildInputs = [
    autoreconfHook intltool pkgconfig libxslt docbook_xsl
  ];

  buildInputs = [
    gtk3 udev systemd
  ];

  postPatch = ''
    sed -i \
      -e "s#\$(\$PKG_CONFIG --variable=systemdsystemunitdir systemd)#$out/etc/systemd/system#g" \
      -e "s#plymouthplugindir=.*#plymouthplugindir=/etc/plymouth/plugins/#" \
      -e "s#plymouththemedir=.*#plymouththemedir=/etc/plymouth/themes#" \
      -e "s#plymouthpolicydir=.*#plymouthpolicydir=/etc/plymouth/#" \
      configure.ac
  '';

  configureFlags = [
    "--with-systemdunitdir=${placeholder "out"}/etc/systemd/system"
    "--localstatedir=/var"
    "--with-logo=/etc/plymouth/logo.png"
    "--with-background-color=0x000000"
    "--with-background-start-color-stop=0x000000"
    "--with-background-end-color-stop=0x000000"
    "--with-release-file=/etc/os-release"
    "--without-system-root-install"
    "--without-rhgb-compat-link"
    "--enable-tracing"
    "--enable-systemd-integration"
    "--enable-pango"
    "--enable-gdm-transition"
    "--enable-gtk"
  ];

  installFlags = [
    "plymouthd_defaultsdir=${placeholder "out"}/share/plymouth"
    "plymouthd_confdir=${placeholder "out"}/etc/plymouth"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/Plymouth;
    description = "A graphical boot animation";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
