{ stdenv, fetchgit, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null
, gmp, libxml2, stoken, zlib, lz4, libtasn1, pcsclite
, autoreconfHook
, makeWrapper
, coreutils, gnugrep, iproute, nettools
, gnused, which
, useModernVpncScript ? true
, ocserv, socket_wrapper, uid_wrapper
}:

assert (openssl != null) == (gnutls == null);

let
  binpath = stdenv.lib.makeBinPath [ coreutils gnugrep iproute nettools gnused which ];
  modern_vpnc_scripts = stdenv.mkDerivation rec {
    pname = "vpnc-scripts";
    version = "20190611";
    nativeBuildInputs = [ makeWrapper gnused which ];
    buildPhase = ''
     substituteInPlace vpnc-script \
       --replace '/sbin:/usr/sbin' '${binpath}'

     sed -i vpnc-script \
         -E \
         -e 's,(/usr|)/s?bin/(\w+),\2,g' \
         -e 's,\[ -x (\w+) \],type -p \1 >/dev/null 2>\&1,g'
   '';
   installPhase = ''
     install -Dm755 -t $out/bin/ vpnc-script
   '';
    src = fetchurl {
      url = "ftp://ftp.infradead.org/pub/${pname}/${pname}-${version}.tar.gz";
      sha256 = "0wv4m4f7k34ic394mslmb9p0skq275935djd1pssjvrkmbvkm5g0";
    };
  };

  # XXX: I don't think this is actually used unless using
  # openconnect directly -- networkmanager-openconnect uses
  # its own 'helper' utility, which makes sense.
  vpnc-script = let f =
    if useModernVpncScript
    then "${modern_vpnc_scripts}/bin/vpnc-script"
    else "${vpnc}/etc/vpnc/vpnc-script";
  in f;
  #in assert builtins.pathExists f; f;

in
stdenv.mkDerivation rec {
  pname = "openconnect";
  #version = "8.05";
  version = "unstable-2019-12-29";

  src = fetchgit {
    # url = https://git.infradead.org/users/dwmw2/openconnect.git;
    url = "https://github.com/${pname}/${pname}";
    rev = "6ec20deab70d2c9b8d5045c8b42e0cf3f4ec39c8";
    sha256 = "1j7qgfqbidly9dpysrk4ixzm8s8xrpk0rqxpf33r6jiyy2pqy7nq";
  };
  #src = fetchurl {
  #  urls = [
  #    "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz"
  #  ];
  #  sha256 = "14i9q727c2zc9xhzp1a9hz3gzb5lwgsslbhircm84dnbs192jp1k";
  #};

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-script}"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ vpnc openssl gnutls gmp libxml2 stoken zlib lz4 libtasn1 pcsclite ];

  passthru = { inherit vpnc-script; };

  checkInputs = [ ocserv socket_wrapper uid_wrapper ];
  doCheck = true;

  meta = {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = http://www.infradead.org/openconnect/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ pradeepchhetri ];
    platforms = stdenv.lib.platforms.linux;
  };
}
