{ stdenv, fetchurl, pkgconfig, systemd
, boost, libsodium, libedit, re2
, net_snmp, lua, protobuf, openssl }: stdenv.mkDerivation rec {
  name = "dnsdist-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "1kz84fmc3q9ds84dlizc85j9vamn0l59nviwkwb5an826a84zclz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ systemd boost libsodium libedit re2 net_snmp lua protobuf openssl ];

  configureFlags = [
    "--enable-libsodium"
    "--enable-re2"
    "--enable-dnscrypt"
    "--enable-dns-over-tls"
    "--with-protobuf=yes"
    "--with-net-snmp"
    "--disable-dependency-tracking"
    "--enable-unit-tests"
    "--enable-systemd"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
