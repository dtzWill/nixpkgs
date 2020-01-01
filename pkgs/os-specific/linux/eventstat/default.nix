{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  pname = "eventstat";
  version = "0.04.08";
  src = fetchzip {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "08a2fg2bl7rf29br1mryix5hp2njy0cjl648lnyiv7wngi341qsm";
  };
  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  meta = with lib; {
    description = "Simple monitoring of system events";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
