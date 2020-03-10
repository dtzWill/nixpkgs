{ stdenv, fetchFromGitHub }:

# this package is working only as root
# in order to work as a non privileged user you would need to suid the bin

stdenv.mkDerivation rec {
  pname = "beep";
  version = "1.4.9";
  src = fetchFromGitHub {
    owner = "spkr-beep";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jmvqk6g5n0wzj9znw42njxq3mzw1769f4db99b83927hf4aidi4";
  };

  makeFlags = [ "DESTDIR=" "prefix=${placeholder "out"}" ];

  meta = {
    description = "The advanced PC speaker beeper";
    homepage = "https://github.com/spkr-beep/beep";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
