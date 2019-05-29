{ stdenv, fetchgit, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.20";
  version = "2019-05-29";

  src = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = version;
     rev = "d99c34f0691a58628094f29cc71568ef43007de6";
     sha256 = "1pinc5pfaa6cbzjgb19gl1kn72w3l7yralycjjhcknz31w5c0a4v";
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
