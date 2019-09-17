{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, libcbor, libressl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "2019-09-17";
  #version = "1.2.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
  #  sha256 = "1pbllhzcrzkgxad00bai7lna8dpkwiv8khx8p20miy661abv956v";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "5bcf1315b9d86cb5e40f14c04343aff4fc3917a3";
    sha256 = "0nas7l29vfs249wsb0jiq6vrlyhs3frm2qpj5p69bf7zk7ir532r";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor udev ];
  propagatedBuildInputs = [ libressl /* libcrypto */ ];

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
