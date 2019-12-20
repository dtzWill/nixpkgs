{ stdenv, fetchurl, iasl, python }:

stdenv.mkDerivation rec {

  name = "seabios-${version}";
  version = "1.13.0";

  src = fetchurl {
    url = "http://code.coreboot.org/p/seabios/downloads/get/${name}.tar.gz";
    sha256 = "0kfp43xm5vm1ln12zkgkwnh46xiiy4r2zbx0qd5cifrbvq4f046s";
  };

  buildInputs = [ iasl python ];

  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  configurePhase = ''
    # build SeaBIOS for CSM
    cat > .config << EOF
    CONFIG_CSM=y
    CONFIG_QEMU_HARDWARE=y
    CONFIG_PERMIT_UNALIGNED_PCIROM=y
    EOF

    make olddefconfig
  '';

  installPhase = ''
    mkdir $out
    cp out/Csm16.bin $out/Csm16.bin
  '';

  meta = with stdenv.lib; {
    description = "Open source implementation of a 16bit X86 BIOS";
    longDescription = ''
      SeaBIOS is an open source implementation of a 16bit X86 BIOS.
      It can run in an emulator or it can run natively on X86 hardware with the use of coreboot.
      SeaBIOS is the default BIOS for QEMU and KVM.
    '';
    homepage = http://www.seabios.org;
    license = licenses.lgpl3;
    maintainers = [ maintainers.tstrobel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

