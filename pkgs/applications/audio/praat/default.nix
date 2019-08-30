{ stdenv, fetchFromGitHub, alsaLib, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "praat";
  version = "6.1.02";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0fq7izrz9vmg5jb8wpmjzlcdkbcgmwdqvafp9i5kv26csjqixclp";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux.alsa makefile.defs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp praat $out/bin
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib gtk2 ];

  meta = {
    description = "Doing phonetics by computer";
    homepage = http://www.fon.hum.uva.nl/praat/;
    license = stdenv.lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    platforms = stdenv.lib.platforms.linux;
  };
}
