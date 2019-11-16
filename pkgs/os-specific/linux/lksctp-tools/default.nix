{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lksctp-tools";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "sctp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ymbywpz1dym21fiadyiavmd71ynws8ghddj7mvw8lmdsfn09iff";
  };

  meta = with stdenv.lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools.";
    homepage = http://lksctp.sourceforge.net/;
    license = with licenses; [ gpl2 lgpl21 ]; # library is lgpl21
    platforms = platforms.linux;
  };
}
