{ stdenv, fetchurl, fetchgit, lz4, snappy, libsodium
# For testing
, coreutils, gawk
}:

stdenv.mkDerivation rec {
  pname = "dedup";
  #version = "1.0";
  version = "2019-05-20";

  #src = fetchurl {
  #  url = "https://dl.2f30.org/releases/${pname}-${version}.tar.gz";
  #  sha256 = "0wd4cnzhqk8l7byp1y16slma6r3i1qglwicwmxirhwdy1m7j5ijy";
  #};
  src = fetchgit {
    url =  git://git.2f30.org/dedup.git;
    rev = "885ea6fad001f60ad32b77e0e830c5339561530c";
    sha256 = "1dng44sj1qbhzk4q7ci772aasfmbcgbb66p19ga768cxaxwy3a7l";
  };

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "out"}/share/man"
  ];

  buildInputs = [ lz4 snappy libsodium ];

  doCheck = true;

  checkInputs = [ coreutils gawk ];
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "data deduplication program";
    homepage = https://git.2f30.org/dedup/file/README.html;
    license = with licenses; [ bsd0 isc ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
