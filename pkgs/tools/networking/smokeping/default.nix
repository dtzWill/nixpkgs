{ stdenv, fetchurl, fping, rrdtool, perlPackages }:

stdenv.mkDerivation rec {
  name = "smokeping-${version}";
  version = "2.7.3";
  src = fetchurl {
    url = "https://oss.oetiker.ch/smokeping/pub/smokeping-${version}.tar.gz";
    sha256 = "1d1nimi9iq1072h5j64dsfyrx5y05w2jqxvzi650d554620da3s3";
  };
  propagatedBuildInputs = [ rrdtool ] ++
    (with perlPackages; [ perl FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty fping NetDNS perlldap NetSSLeay IOSocketSSL MozillaCA ]);

  postInstall = ''
    mv $out/htdocs/smokeping.fcgi.dist $out/htdocs/smokeping.fcgi
  '';
  meta = {
    description = "Network latency collector";
    homepage = http://oss.oetiker.ch/smokeping;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.erictapen ];
  };
}
