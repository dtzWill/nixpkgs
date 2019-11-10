{ stdenv, fetchFromGitHub, libtool, autoreconfHook, pkgconfig
, sysfsutils
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
, curl ? null, libxml2 ? null, openssl ? null, withNistBeacon ? false
  # Systems that support RDRAND but not AES-NI require libgcrypt to use RDRAND as an entropy source
, libgcrypt ? null, withGcrypt ? true
  # Not sure if jitterentropy is safe to use for cryptography
  # and thus a default entropy source
, jitterentropy ? null, withJitterEntropy ? false
, libp11 ? null, opensc ? null, withPkcs11 ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.8";
  #version = "2019-06-06";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = "rng-tools";
    rev = "v${version}";
    #rev = "9fc873c5af0e392632e6b736938b811f7ca97251";
    sha256 = "1clm9i9xg3j79q0d6vinn6dx0nwh1fvzcmkqpcbay7mwsgkknvw2";
  };

  postPatch = ''
    cp README.md README

    ${optionalString withPkcs11 ''
      substituteInPlace rngd.c \
        --replace /usr/lib64/opensc-pkcs11.so ${opensc}/lib/opensc-pkcs11.so
    ''}
  '';

  nativeBuildInputs = [ autoreconfHook libtool pkgconfig ];

  configureFlags = [
    (withFeature   withGcrypt        "libgcrypt")
    (enableFeature withJitterEntropy "jitterentropy")
    (withFeature   withNistBeacon    "nistbeacon")
    (withFeature   withPkcs11        "pkcs11")
  ];

  buildInputs = [ sysfsutils ]
    ++ optionals withGcrypt        [ libgcrypt ]
    ++ optionals withJitterEntropy [ jitterentropy ]
    ++ optionals withNistBeacon    [ curl libxml2 openssl ]
    ++ optionals withPkcs11        [ libp11 openssl ];

  # This shouldn't be necessary but is as of 6.7
  NIX_LDFLAGS = optionalString withPkcs11 "-lcrypto";

  enableParallelBuilding = true;

  # For cross-compilation
  makeFlags = [ "AR:=$(AR)" ];

  doInstallCheck = true;

  meta = {
    description = "A random number generator daemon";
    homepage = https://github.com/nhorman/rng-tools;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
