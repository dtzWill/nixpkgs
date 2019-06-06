{ stdenv, fetchgit, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.20";
  version = "2019-06-06";

  src = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = version;
     rev = "7c4e38f83bb90ebb5b0cffb7328d176928c39c64";
     sha256 = "1119d0jmhn03y51aq9lplhhb2hh92balf9wkfvnrjk8hj9vsfxfa";
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
