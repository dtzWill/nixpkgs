{ lib, mkDerivation, fetchFromGitHub
, cmake, ffmpeg, libopus, qtbase, qtmultimedia, qtsvg , pkgconfig, protobuf
, openssl, python3Packages
, useQtGamePad ? false, qtgamepad ? null
, SDL2 /* needed either way, I think? */ }:

mkDerivation rec {
  pname = "chiaki";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "thestr4ng3r";
    repo = "chiaki";
    fetchSubmodules = true;
    sha256 = "1dgfdiq1l59mx76vm6wqfjj3bxbp4kyyivnqr4g7qaysbcazyi9h";
  };

  nativeBuildInputs = [
    cmake pkgconfig protobuf python3Packages.python python3Packages.protobuf
  ];
  buildInputs = [ ffmpeg openssl libopus qtbase qtmultimedia qtsvg protobuf SDL2 ]
    ++ lib.optional useQtGamePad qtgamepad;

  cmakeFlags = [
    "-DCHIAKI_GUI_ENABLE_SDL_GAMECONTROLLER=${if useQtGamePad then "OFF" else "ON"}"
    "-DCHIAKI_GUI_ENABLE_QT_GAMEPAD=${if useQtGamePad then "ON" else "OFF"}"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/thestr4ng3r/chiaki";
    description = "Free and Open Source PS4 Remote Play Client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.all;
  };
}
