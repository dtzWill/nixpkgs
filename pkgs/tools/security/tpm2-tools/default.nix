{ stdenv, fetchurl, lib
, curl, pandoc, pkgconfig, openssl, tpm2-tss }:

stdenv.mkDerivation rec {
  pname = "tpm2-tools";
  version = "4.1";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1wnw4i2m6dkafqjjma8mxw9419py2v1knhn3zf1gaizdabskgkh7";
  };

  nativeBuildInputs = [ pandoc pkgconfig ];
  buildInputs = [
    curl openssl tpm2-tss
  ];

  doCheck = true;

  meta = with lib; {
    description = "Command line tools that provide access to a TPM 2.0 compatible device";
    homepage = https://github.com/tpm2-software/tpm2-tools;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
