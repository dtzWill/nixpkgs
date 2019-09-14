{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.02.03";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1b5s50dc8ag6k631nfp09chrqfpwai0r9ld822xqwp3qlszp0pv9";
  };
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/fnotifystat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
