{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "sbase";
  version = "unstable-2019-08-05";

  src = fetchgit {
    url = "git://git.suckless.org/${pname}";
    rev = "39f92650d33d038be5c5429e37d2d0c624b6ab38";
    sha256 = "0md0gyrc7z4xda74hk7xg0lcaxjb054bs32qcshvx757k7d4hg2r";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "suckless unix tools";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
