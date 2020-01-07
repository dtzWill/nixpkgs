{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.11.0";
  pname = "yara";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "0mx3xm2a70fx8vlynkavq8gfd9w5yjcix5rx85444i2s1h6kcd0j";
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ pcre ]
    ++ stdenv.lib.optionals withCrypto [ openssl ]
    ++ stdenv.lib.optionals enableMagic [ file ]
    ++ stdenv.lib.optionals enableCuckoo [ jansson ]
  ;

  preConfigure = "./bootstrap.sh";

  configureFlags = [
    (stdenv.lib.withFeature withCrypto "crypto")
    (stdenv.lib.enableFeature enableMagic "magic")
    (stdenv.lib.enableFeature enableCuckoo "cuckoo")
  ];

  meta = with stdenv.lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage    = http://Virustotal.github.io/yara/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.all;
  };
}
