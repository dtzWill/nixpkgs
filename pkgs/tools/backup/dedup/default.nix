{ stdenv, fetchurl, fetchgit, lz4, snappy, libsodium
# For testing
, coreutils, gawk
}:

stdenv.mkDerivation rec {
  pname = "dedup";
  #version = "1.0";
  version = "2019-05-17";

  #src = fetchurl {
  #  url = "https://dl.2f30.org/releases/${pname}-${version}.tar.gz";
  #  sha256 = "0wd4cnzhqk8l7byp1y16slma6r3i1qglwicwmxirhwdy1m7j5ijy";
  #};
  src = fetchgit {
    url =  git://git.2f30.org/dedup.git;
    rev = "c86adacd4c9ec47d68823fbb768ec3fc7e5c23c0";
    sha256 = "121fzkp3xq5dasrnsm26ldhdgr9jna7v63wv7lv8cqbqx6dmmakj";
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
