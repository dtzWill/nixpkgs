{ stdenv, fetchgit, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.20";
  version = "2019-07-08";

  src = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = version;
     rev = "b839b3150efdbfde0cf60b9629dcbf01f8fb0468";
     sha256 = "1bdi85rczrq9mj8rx9xjaasn0skwc9b8fi71axyqqc6561qr2511";
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
