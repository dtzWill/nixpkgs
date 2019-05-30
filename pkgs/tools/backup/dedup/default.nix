{ stdenv, fetchurl, fetchgit, lz4, snappy, libsodium
# For testing
, coreutils, gawk
}:

stdenv.mkDerivation rec {
  pname = "dedup";
  version = "2.0";
#  version = "2019-05-22";

  src = fetchurl {
    url = "https://dl.2f30.org/releases/${pname}-${version}.tar.gz";
    sha256 = "0n5kkni4d6blz3s94y0ddyhijb74lxv7msr2mvdmj8l19k0lrfh1";
  };
  #src = fetchgit {
  #  url =  git://git.2f30.org/dedup.git;
  #  rev = "edba7a881758ccfa9cd11ba4a4b60fe83446701e";
  #  sha256 = "12k7k6fnhdhhaklhhli8rsh0g1zdgd5a4y1rc3s44m76k9ln4yv0";
  #};

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
    description = "Data deduplication program";
    homepage = https://git.2f30.org/dedup/file/README.html;
    license = with licenses; [ bsd0 isc ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
