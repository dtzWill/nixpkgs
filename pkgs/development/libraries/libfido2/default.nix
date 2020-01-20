{ stdenv, fetchFromGitHub, cmake, pkgconfig, libcbor, libressl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "unstable-2020-01-20";
  #version = "1.3.0";
  #src = fetchurl {
  #  url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
  #  sha256 = "1izyl3as9rn7zcxpsvgngjwr55gli5gy822ac3ajzm65qiqkcbhb";
  #};

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "2ba6c6afe5f2d1717bf366da043ccb515fbed8de";
    sha256 = "1s7yjgbyqv5mrrizggch7592xfylfqs9h2hrcmnp4qr46hvikdq5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor libressl udev ];

  cmakeFlags = [ "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d" ];

  # Fix undersized buffer, at least GCC believes so (and it's not obvious to me it's wrong?)
  # Only a few bytes more and it was adusted just one or two commits ago anyway.
  postPatch = ''
		substituteInPlace src/log.c \
      --replace '#define XXDLEN	16' \
                '#define XXDLEN	32'
  '';

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = https://github.com/Yubico/libfido2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];

  };
}
