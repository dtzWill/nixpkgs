{ stdenv, fetchFromGitHub, cmake, cfitsio, libusb, zlib, boost, libnova
, curl, libjpeg, gsl }:

stdenv.mkDerivation rec {
  pname = "indilib";
  version = "1.8.3";
  src = fetchFromGitHub {
    owner = pname;
    repo = "indi";
    rev = "v${version}";
    sha256 = "1rxmc9chk90szypwg3cz1n5a1bqazc0vwip2sk20y71w049ckiqs";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'UDEVRULES_INSTALL_DIR "/lib/udev/rules.d"' \
                 'UDEVRULES_INSTALL_DIR "''${CMAKE_INSTALL_PREFIX}/lib/udev/rules.d"'
  '';

  buildInputs = [ curl cmake cfitsio libusb zlib boost
                            libnova libjpeg gsl ];

  meta = {
    homepage = https://www.indilib.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    description = "Implementaion of the INDI protocol for POSIX operating systems";
    platforms = stdenv.lib.platforms.unix;
  };
}
