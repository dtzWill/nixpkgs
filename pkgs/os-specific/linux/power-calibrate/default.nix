{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "power-calibrate";
  version = "0.01.30";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "14894gs3021x4k2rrlcv00b26wcnx6isw64hwgbnn6djqcp7jykv";
  };
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];
  meta = with lib; {
    description = "Tool to calibrate power consumption";
    homepage = https://kernel.ubuntu.com/~cking/power-calibrate/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
