{ stdenv, fetchgit, autoreconfHook, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  pname = "evtest";
  version = "1.34";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/${pname}";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "0r0vnaw69rg2n3bydj7zwaqzp4wr810k9mi4d5yzs5qdd6h9qhfi";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
