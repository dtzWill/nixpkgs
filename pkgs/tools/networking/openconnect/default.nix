{ stdenv, fetchgit, fetchurl, pkgconfig, autoreconfHook, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib, lz4, libtasn1
, pcsclite }:

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  name = "openconnect-7.08.99git";

  src = fetchgit {
    url = git://git.infradead.org/users/dwmw2/openconnect.git;
    rev = "a25e844477b4662f0ede159a3c633c91597c8813";
    sha256 = "1pc9bxlb76p2a790df725dv4666y8q41gl870z3dzdhvsmgx75bi";
  };
  #src = fetchurl {
  #  urls = [
  #    "ftp://ftp.infradead.org/pub/openconnect/${name}.tar.gz"
  #  ];
  #  sha256 = "00wacb79l2c45f94gxs63b9z25wlciarasvjrb8jb8566wgyqi0w";
  #};

  outputs = [ "out" "dev" ];

  #preConfigure = ''
  #    export PKG_CONFIG=${pkgconfig}/bin/pkg-config
  #    export LIBXML2_CFLAGS="-I ${libxml2.dev}/include/libxml2"
  #    export LIBXML2_LIBS="-L${libxml2.out}/lib -lxml2"
  #  '';

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib lz4 libtasn1 pcsclite ];

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ pradeepchhetri ];
    platforms = stdenv.lib.platforms.linux;
  };
}
