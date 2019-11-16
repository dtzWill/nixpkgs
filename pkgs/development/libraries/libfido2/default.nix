{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, libcbor, openssl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2019-11-15";
  #version = "1.2.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
  #  sha256 = "1pbllhzcrzkgxad00bai7lna8dpkwiv8khx8p20miy661abv956v";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "ca27217e1e54fb2de56a09b46d43a247483e6c11";
    sha256 = "00zqfbfk9j47wnsk89gh1jdzqp9zj5ayk726pzh2md4v7f504h5b";
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
