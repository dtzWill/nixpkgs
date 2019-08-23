{ stdenv, fetchurl, perl, icu, zlib, gmp, readline
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "rakudo-star";
  version = "2019.03";

  src = fetchurl {
    url    = "https://rakudo.org/dl/star/${pname}-${version}.tar.gz";
    sha256 = "0260kk3s7pz3aw8bcnqxx983dpkhhw7080aswx4nqkrb7bg6j2k4";
  };

  buildInputs = [ icu zlib gmp readline perl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--backends=moar"
      "--gen-moar"
      "--gen-nqp"
    ];

  meta = with stdenv.lib; {
    description = "A Perl 6 implementation";
    homepage    = https://www.rakudo.org;
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra ];
  };
}
