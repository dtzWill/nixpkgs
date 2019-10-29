{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, libcbor, openssl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2019-10-22";
  #version = "1.2.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
  #  sha256 = "1pbllhzcrzkgxad00bai7lna8dpkwiv8khx8p20miy661abv956v";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "b2567a9fd3521de4690cef9dc3e451c0f292a7f5";
    sha256 = "15njzmzr9r0wyqp6anrz0hxwgbxirz6qjx2r8ib5bdnfknijh6b9";
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
