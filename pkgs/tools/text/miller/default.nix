{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";
  version = "5.6.1";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = pname;
    rev = "v${version}";
    sha256 = "18pgp2paj3ynrjiil3c2adbyczgvmp3sjhqbccp017d3sl5jg945";
  };

  nativeBuildInputs = [ autoreconfHook flex libtool ];

  meta = with stdenv.lib; {
    description = "Miller is like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON.";
    homepage    = "http://johnkerl.org/miller/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = platforms.all;
  };
}
