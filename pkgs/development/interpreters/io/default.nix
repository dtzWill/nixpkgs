{ stdenv, fetchFromGitHub, cmake, zlib, sqlite, gmp, libffi, cairo,
  ncurses, freetype, libGLU_combined, libpng, libtiff, libjpeg, readline, libsndfile,
  libxml2, freeglut, libsamplerate, pcre, libevent, libedit, yajl,
  python3, openssl, glfw, pkgconfig, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "io-${version}";
  version = "2017.09.06";
  src = fetchFromGitHub {
    owner = "stevedekorte";
    repo = "io";
    rev = version;
    sha256 = "07rg1zrz6i6ghp11cm14w7bbaaa1s8sb0y5i7gr2sds0ijlpq223";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib sqlite gmp libffi cairo ncurses freetype
    libGLU_combined libpng libtiff libjpeg readline libsndfile libxml2
    freeglut libsamplerate pcre libevent libedit yajl
    pkgconfig glfw openssl libXdmcp
    python3
  ];

  # Fixes things, should be refined/investigated
  hardeningDisable = [ "all" ];

  preInstall = ''
    export HOME=$PWD
  '';

  meta = with stdenv.lib; {
    description = "Io programming language";
    homepage = http://iolanguage.org/;
    license = licenses.bsd3;

    maintainers = with maintainers; [
      raskin
      maggesi
      vrthra
    ];
    platforms = [ "x86_64-linux" ];
  };
}
