{ stdenv, lib, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name = "musescore";
  version = "3.1.0";

  src = fetchzip {
    # Not sure why not available on musescore website, check when next upgrade please!
    url = "https://github.com/musescore/MuseScore/releases/download/v3.1/MuseScore-${version}.zip";
    sha256 = "05zrbjs3gjxrqpxa5dxcwfxgqpjv3lqzw5vrwrzilq0gifd0ap8r";
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
