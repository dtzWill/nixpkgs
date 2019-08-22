{ stdenv, fetchurl, gettext, bzip2 }:

stdenv.mkDerivation rec {
  pname = "sysstat";
  version = "12.1.6";

  src = fetchurl {
    url = "http://pagesperso-orange.fr/sebastien.godard/sysstat-12.1.6.tar.xz";
    sha256 = "0agi17n82k363mf9f7cky3isq195hw112vs98v26yfhm0v2g6lpp";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2.bin}/bin/bzip2
    export SYSTEMCTL=systemctl
  '';

  makeFlags = "SYSCONFIG_DIR=$(out)/etc IGNORE_FILE_ATTRIBUTES=y CHOWN=true";
  installTargets = "install_base install_nls install_man";

  patches = [ ./install.patch ];

  meta = {
    homepage = http://sebastien.godard.pagesperso-orange.fr/;
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
