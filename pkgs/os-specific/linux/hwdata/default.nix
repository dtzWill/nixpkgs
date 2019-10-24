{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.328";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "0ghcflyx0clc8qcb95m6q6cbf35wb9qqcbi9669bghsjjm51lhns";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1k9l8s35skb6swx13wzssrpq4s4v0c82jbbawa72kkcjgdl31pag";

  meta = {
    homepage = https://github.com/vcrhonek/hwdata;
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
