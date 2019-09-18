{ lib, mkDerivation, fetchFromGitHub, cmake, qttools, qtbase, networkmanager-qt, modemmanager-qt }:

mkDerivation rec {
  pname = "nm-tray";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "palinek";
    repo = pname;
    rev = version;
    sha256 = "08c86kd613wlvw9571q7a3lb7g6skyyasjw6h1g543rbl4jn2c2v";
  };

  postPatch = ''
    sed -i -e '1i#include <QMetaEnum>' src/nmmodel.cpp
  '';

  nativeBuildInputs = [ cmake qttools ];

  cmakeFlags = [ "-DWITH_MODEMMANAGER_SUPPORT=ON" ];

  buildInputs = [ qtbase networkmanager-qt modemmanager-qt ];

  meta = with lib; {
    description = "Simple Network Manager frontend written in Qt";
    longDescription = ''
      nm-tray is a simple NetworkManager front end with information icon residing
      in system tray (like e.g. nm-applet). It's a pure Qt application. For
      interaction with NetworkManager it uses API provided by KF5::NetworkManagerQt
      -> plain DBus communication.
    '';
    homepage = "https://github.com/palinek/nm-tray";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
