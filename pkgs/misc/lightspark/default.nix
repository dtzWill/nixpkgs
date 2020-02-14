{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, cmake, curl, zlib, ffmpeg, glew, pcre
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, gnome2, lzma, nasm
, glibmm
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    sha256 = "04wn6d6gmpf848x0yghw26m9syv0hm6q5dwqiw3fxhs155jjqfgv";
  };

  postPatch = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  patches = [
    # Fix build w/boost 1.72, upstream PR409
    (fetchpatch {
      url = "https://github.com/lightspark/lightspark/pull/409/commits/a702f587fe5c130da9186e73a7d5e3a8b697923a.patch";
      sha256 = "15hg13qmvl0xs3jys74mwm2q2q5bjamzf60vf48xrb1i8mymnlza";
    })
  ];

  buildInputs = [
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    gnome2.pango lzma nasm glibmm
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
  };
}
