{ stdenv, lib, fetchurl
, cmocka, doxygen, ibm-sw-tpm2, iproute, openssl, perl, pkgconfig, procps
, uthash, which }:

stdenv.mkDerivation rec {
  pname = "tpm2-tss";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "19jg09sxy3aj4dc1yv32jjv0m62cnmhjlw02jbh4d4pk2439m4l2";
  };

  nativeBuildInputs = [
    doxygen perl pkgconfig
  ];
  buildInputs = [
    openssl
  ];

  postPatch = "patchShebangs script";

  configureFlags = [
    "--enable-unit"
    "--enable-integration"
  ];

  checkInputs = [
    ibm-sw-tpm2 iproute procps which
    cmocka uthash
  ];

  doCheck = true;

  enableParallelBuilding = true;

  postInstall = ''
    # Do not install the upstream udev rules, they rely on specific
    # users/groups which aren't guaranteed to exist on the system.
    rm -R $out/lib/udev
  '';

  dontPatchELF = true; # rpath

  meta = with lib; {
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    homepage = https://github.com/tpm2-software/tpm2-tss;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
