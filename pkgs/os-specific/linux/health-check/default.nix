{ stdenv, lib, fetchurl, json_c, libbsd }:

stdenv.mkDerivation rec {
  pname = "health-check";
  version = "0.03.06";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1kliw6l3im8ris9fs7ag0371bdpn4d3psdvcvcj8ffbn8p57skck";
  };
  buildInputs = [ json_c libbsd ];
  makeFlags = [ "JSON_OUTPUT=y" "FNOTIFY=y" ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completions/completions"
  ];
  meta = with lib; {
    description = "Process monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/health-check/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
