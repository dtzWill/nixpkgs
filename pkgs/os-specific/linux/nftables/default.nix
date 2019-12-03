{ stdenv, fetchurl, pkgconfig, bison, flex
, libmnl, libnftnl, libpcap
, gmp, jansson, readline
, withXtables ? false , iptables
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.3";
  name = "nftables-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/nftables/files/${name}.tar.bz2";
    sha256 = "0y6vbqp6x8w165q65h4n9sba1406gaz0d4744gqszbm7w9f92swm";
  };

  configureFlags = [
    "--disable-man-doc"
    "--with-json"
  ] ++ optional withXtables "--with-xtables";

  nativeBuildInputs = [ pkgconfig bison flex ];

  buildInputs = [
    libmnl libnftnl libpcap
    gmp readline jansson
  ] ++ optional withXtables iptables;

  meta = {
    description = "The project that aims to replace the existing {ip,ip6,arp,eb}tables framework";
    homepage = "https://netfilter.org/projects/nftables/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
