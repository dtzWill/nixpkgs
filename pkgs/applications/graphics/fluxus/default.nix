{ stdenv
, fetchFromGitLab
, alsaLib
, bzip2
, fftw
, freeglut
, freetype
, glew
, libjack2
, libGL
, libGLU
, libjpeg
, liblo
, libpng
, libsndfile
, libtiff
, ode
, openal
, openssl
, racket
, scons
, zlib
}:
let
  libs = [
    alsaLib
    bzip2
    fftw
    freeglut
    freetype
    glew
    libjack2
    libGL
    libGLU
    libjpeg
    liblo
    libpng
    libsndfile
    libtiff
    ode
    openal
    openssl
    zlib
  ];
  libPath = stdenv.lib.concatStringsSep " " (map (l: l.out + "/lib") libs);
in
stdenv.mkDerivation rec {
  name = "fluxus-${version}";
  version = "0.19";
  src = fetchFromGitLab {
    owner = "nebogeo";
    repo = "fluxus";
    rev = "ba9aee218dd4a9cfab914ad78bdb6d59e9a37400";
    hash = "sha256:0mwghpgq4n1khwlmgscirhmcdhi6x00c08q4idi2zcqz961bbs28";
  };

  buildInputs = [
    alsaLib
    fftw
    freeglut.dev
    freetype
    glew
    libjack2
    libjpeg.dev
    liblo
    libsndfile.dev
    libtiff.dev
    ode
    openal
    openssl.dev
    racket
    scons
  ];
  patches = [ ./fix-build.patch ];
  buildPhase = ''
    scons \
      Prefix="$out" \
      RacketPrefix="${racket}" \
      RacketInclude="${racket}/include/racket" \
      RacketLib="${racket}/lib/racket" \
      LIBPATH="${libPath}" \
      DESTDIR="build"
  '';
  installPhase = ''
    mkdir -p $out
    cp -r build$out/* $out/
  '';

  meta = with stdenv.lib; {
    description = "Livecoding environment for 3D graphics, sound, and games";
    license = licenses.gpl2;
    homepage = http://www.pawfal.org/fluxus/;
    maintainers = [ maintainers.brainrape ];
  };
}
