{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, libcbor, openssl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2019-11-19";
  #version = "1.2.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
  #  sha256 = "1pbllhzcrzkgxad00bai7lna8dpkwiv8khx8p20miy661abv956v";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "9343b25536ad4ad6f33b5ae28d310634cec3812a";
    sha256 = "04q03ysjvwpa1mi654akxfc1yy14kv1bysizhgzn82jmw9l6gw44";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor udev ];
  propagatedBuildInputs = [ openssl /* libcrypto */ ];

  cmakeFlags = [ "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d" ];

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = https://github.com/Yubico/libfido2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];

  };
}
