{ stdenv, fetchurl, pciutils }: with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "gnu-efi";
  version = "3.0.10";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1vagz9b1z6rwy3f0n2pwrp19l4sx4hs9yai6cy6f7hzhlniq487i";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "CC=${stdenv.cc.targetPrefix}gcc"
    "AS=${stdenv.cc.targetPrefix}as"
    "LD=${stdenv.cc.targetPrefix}ld"
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
  ] ++ stdenv.lib.optional stdenv.isAarch32 "ARCH=arm"
    ++ stdenv.lib.optional stdenv.isAarch64 "ARCH=aarch64";

  meta = with stdenv.lib; {
    description = "GNU EFI development toolchain";
    homepage = https://sourceforge.net/projects/gnu-efi/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
