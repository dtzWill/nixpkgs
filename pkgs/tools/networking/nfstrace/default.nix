{ cmake, fetchFromGitHub, gcc7Stdenv, libpcap, stdenv }:

gcc7Stdenv.mkDerivation rec {
  pname = "nfstrace";
  version = "0.4.3.2";

  src = fetchFromGitHub {
    owner = "epam";
    repo = "nfstrace";
    rev = "${version}";
    sha256 = "sha256:1djsyn7i3xp969rnmsdaf5vwjiik9wylxxrc5nm7by00i76c1vsg";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpcap ];

  meta = with stdenv.lib; {
    homepage = "http://epam.github.io/nfstrace/";
    description = "NFS and CIFS tracing/monitoring/capturing/analyzing tool";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
