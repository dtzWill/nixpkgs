{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, libcbor, openssl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2019-11-01";
  #version = "1.2.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
  #  sha256 = "1pbllhzcrzkgxad00bai7lna8dpkwiv8khx8p20miy661abv956v";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "6a628b3d3a9d62a58f94d48340ef9eeca2d672b9";
    sha256 = "1fk3b6r1rk06gnd7b3fpggyyb7nln1bsf9g52brz6hk5kbdzqj56";
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
