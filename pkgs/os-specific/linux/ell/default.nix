{ stdenv, fetchgit, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.20";
  version = "2019-06-13";

  src = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = version;
     rev = "304b92cef6265cfabdc10654cdc27d0cdbfa5772";
     sha256 = "1119d0jmhn04y51aq9lplhhb2hh92balf9wkfvnrjk8hj9vsfxfa";
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
