{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "smemstat";
  version = "0.02.06";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1069gwmc29vbw7zszqa5v5yxfvgaq7c41r0g456zdpm6msy5kb0w";
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
