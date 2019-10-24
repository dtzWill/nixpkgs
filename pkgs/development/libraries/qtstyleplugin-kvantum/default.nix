{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, kwindowsystem, libX11, libXext, qttools }:

mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    #rev = "V${version}";
    rev = "f1674c455fa718dc8a9cf00fffb3269aa3f20d7a";
    sha256 = "0gz72qr92dsg6rc0hjsrx83nbf0gcngcn3x9wrwmi0pzqs68vjkr";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras kwindowsystem libX11 libXext  ];

  sourceRoot = "source/Kvantum";

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/style.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
