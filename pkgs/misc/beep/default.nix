{ stdenv, fetchFromGitHub }:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation rec {
  pname = "beep";
  version = "1.4.7";
  src = fetchFromGitHub {
    owner = "spkr-beep";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dnbvzzxvajc7pl1165wb3l74pfcqcdg12rcjcw86qqy954dx8my";
  };

  makeFlags = [ "DESTDIR=" "prefix=${placeholder "out"}" ];

  meta = {
    description = "The advanced PC speaker beeper";
    homepage = "https://github.com/spkr-beep/beep";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
