{ stdenv, fetchgit, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.20";
  version = "2019-06-04";

  src = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = version;
     rev = "2652cba364aa2e18c39a23ba00fa5ca88f120730";
     sha256 = "1xghln7fwqqcqnidrrwz8f24xav0rwg6802bp8pkmrssqmb1ja91";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/libs/ell/ell.git;
    description = "Embedded Linux Library";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
