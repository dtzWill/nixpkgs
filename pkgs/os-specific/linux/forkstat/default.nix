{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.13";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "01ih89yw9gi6j3l40q5m26la1y0p1jidkxs3yffbdiqm6gwz0xbx";
  };
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = "https://kernel.ubuntu.com/~cking/forkstat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
