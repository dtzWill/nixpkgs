{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "lksctp-tools";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "sctp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x4fwzrlzvfa3vcpja97m8w5g9ir2zrh4zs7zksminrnmdrs0dsr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools.";
    homepage = http://lksctp.sourceforge.net/;
    license = with licenses; [ gpl2 lgpl21 ]; # library is lgpl21
    platforms = platforms.linux;
  };
}
