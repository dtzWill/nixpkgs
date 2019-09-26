{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "smemstat";
  version = "0.02.05";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "00586w6f1cq7rayv6galh9qxk7wrz62zbha9qhrb1cf85axchvbw";
  };
  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/smemstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
