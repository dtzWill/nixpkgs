{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, pkgconfig
, libxslt, openssl, xz, zlib, elf-header }:

let
  systems = [ "/run/current-system/kernel-modules" "/run/booted-system/kernel-modules" "" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in stdenv.mkDerivation rec {
  pname = "kmod";
  version = "26";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/${pname}/${pname}-${version}.tar.xz";
    sha256 = "17dvrls70nr3b3x1wm8pwbqy4r8a5c20m0dhys8mjhsnpg425fsp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxslt ];
  buildInputs = [ openssl xz zlib ] ++ lib.optional stdenv.isDarwin elf-header;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-xz"
    "--with-zlib"
    "--with-modulesdirs=${modulesDirs}"
  ];

  patches = [
    ./module-dir.patch
  ] ++ [
    (fetchpatch {
      name = "only-libcrypto-not-all-of-openssl.patch";
      url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/patch/?id=8e266b9eeffa3c1fc4dca0081c0553f8c2a488c0";
      sha256 = "05wcazizgk8sz8kyk998ai24pzmg60simh1rbmhzm8ksnl47qh6k";
    })
    (fetchpatch {
      name = "no-dolt.patch";
      url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/patch/?id=f8b8d7b330433511d19a936ddfc7b7d1af5490b5";
      sha256 = "1ri1g891rgagfi3ncvldxnbnypy2bzr1p0rsvw0bc9bqq9dbhfna";
      excludes = [ ".gitignore" ];
    })
    (fetchpatch {
      name = "module-unloading-not-supported-message.patch";
      url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/patch/?id=ea3e508f61251b16567f888042f6c4c60b48a4e0";
      sha256 = "0ajc0nckpr865bkglqrrw2j927y6hlxj58npvcxbgvhz1pbmb0pp";
    })
    (fetchpatch {
      name = "pkcs7-for-compat-beyond-openssl.patch";
      url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/patch/?id=628677e066198d8658d7edd5511a5bb27cd229f5";
      sha256 = "08swzimp5fp39d5rkgjj8g0z61hxxbgva27zasraishdb0klv74b";
    })
  ]
    ++ lib.optional stdenv.isDarwin ./darwin.patch;

  postInstall = ''
    for prog in rmmod insmod lsmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/bin/$prog
    done

    # Backwards compatibility
    ln -s bin $out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
