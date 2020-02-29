{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.02.22";
  
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0r355b9syqa2nhfy8ksvxyy5d58v0isf983842js091s6liy0x7g";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  
  meta = with lib; {
    description = "Laptop power measuring tool";
    homepage = "https://kernel.ubuntu.com/~cking/powerstat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
