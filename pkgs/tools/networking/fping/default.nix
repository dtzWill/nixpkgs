{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "4.2";

  src = fetchurl {
    url = "https://fping.org/dist/${pname}-${version}.tar.gz";
    sha256 = "0jmnf4vmr43aiwk3h2b5qdsb95gxar8gz1yli8fswnm9nrs9ccvx";
  };

  configureFlags = [ "--enable-ipv6" "--enable-ipv4" ];

  meta = with stdenv.lib; {
    homepage = http://fping.org/;
    description = "Send ICMP echo probes to network hosts";
    maintainers = with maintainers; [ the-kenny ];
    license = licenses.bsd0;
    platforms = platforms.all;
  };
}
