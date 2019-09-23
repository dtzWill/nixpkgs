{ stdenv, fetchurl, lib, pkgconfig, tpm2-tss, glib, which
, cmocka, ibm-sw-tpm2, dbus
 }:

stdenv.mkDerivation rec {
  pname = "tpm2-abrmd";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1lbfhyyh9k54r8s1h8ca2czxv4hg0yq984kdh3vqh3990aca0x9a";
  };

  configureFlags = [
    "--enable-unit"
    "--enable-integration"
  ];

  postPatch = ''
    patchShebangs ./scripts
  '';

  nativeBuildInputs = [ pkgconfig which ];
  buildInputs = [ tpm2-tss glib ];
  checkInputs = [ cmocka ibm-sw-tpm2 dbus ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "TPM2 Access Broker & Resource Management Daemon implementing the TCG spec";
    homepage = https://github.com/tpm2-software/tpm2-abrmd;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
