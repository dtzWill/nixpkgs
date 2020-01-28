{ stdenv, mkDerivation, lib, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns, qtquickcontrols2
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.4.1";

  src = fetchzip {
    url = "https://github.com/musescore/MuseScore/releases/download/v${version}/MuseScore-${version}.zip";
    sha256 = "01i1c79blg0a04qkvm2czds5zxgvg5lq7mx69k24zxs08r319lbg";
    stripRoot = false;
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
  ] ++ lib.optional (lib.versionAtLeast freetype.version "2.5.2") "-DUSE_SYSTEM_FREETYPE=ON";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtscript qtsvg qttools qtwebengine qtxmlpatterns
    qtquickcontrols2
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = https://musescore.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever ];
    platforms = platforms.linux;
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
