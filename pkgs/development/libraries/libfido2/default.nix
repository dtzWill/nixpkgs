{ stdenv, fetchFromGitHub, cmake, pkgconfig, libcbor, libressl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2020-01-23";
  #version = "1.3.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
  #  sha256 = "1izyl3as9rn7zcxpsvgngjwr55gli5gy822ac3ajzm65qiqkcbhb";
  #};

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "dcfbedb865a2951a26f01c8b8cba0ca7531350e2";
    sha256 = "07fzmcg0hnsk0bknqkzslym1hibv65cmc1mz9mz7apam2896xqvk";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor libressl udev ];

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
