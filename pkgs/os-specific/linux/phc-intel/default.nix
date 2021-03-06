{ stdenv, fetchurl, kernel, which }:

# Don't bother with older versions, though some might even work:
assert stdenv.lib.versionAtLeast kernel.version "4.10";

let
  release = "0.4.0";
  revbump = "rev31"; # don't forget to change forum download id...
in stdenv.mkDerivation rec {
  name = "linux-phc-intel-${version}-${kernel.version}";
  version = "${release}-${revbump}";

  src = fetchurl {
    sha256 = "0a9imjz5jwrmxrvf56fd5na7z8wg7mq7a3fy4m395zmc39563vmd";
    url = "http://www.linux-phc.org/forum/download/file.php?id=201";
    name = "phc-intel-pack-${revbump}.tar.bz2";
  };

  nativeBuildInputs = [ which ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = with kernel; [
    "DESTDIR=$(out)"
    "KERNELSRC=${dev}/lib/modules/${modDirVersion}/build"
  ];

  configurePhase = ''
    make $makeFlags brave
  '';

  enableParallelBuilding = false;

  installPhase = ''
    install -m 755   -d $out/lib/modules/${kernel.modDirVersion}/extra/
    install -m 644 *.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with stdenv.lib; {
    description = "Undervolting kernel driver for Intel processors";
    longDescription = ''
      PHC is a Linux kernel patch to undervolt processors. This can divide the
      power consumption of the CPU by two or more, increasing battery life
      while noticably reducing fan noise. This driver works only on supported
      Intel architectures.
    '';
    homepage = http://www.linux-phc.org/;
    downloadPage = "http://www.linux-phc.org/forum/viewtopic.php?f=7&t=267";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    broken = false; # stdenv.lib.versionAtLeast kernel.version "5.3";
  };
}
