{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "uchardet";
  version = "0.0.6";

  outputs = [ "bin" "out" "man" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "0q9c02b6nmw41yfsiqsnphgc3f0yg3fj31wkccp47cmwvy634lc3";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  doCheck = true;

  NIX_CFLAGS_COMPILE = if stdenv.isx86_32 then
    # Fix tests and ensure consistent results across archs
    # https://bugs.freedesktop.org/show_bug.cgi?id=101033
    # (found in debian's packaging 'rules')
    [ "-ffloat-store" ]
    else
    # (avoid rebuild)
    null;


  meta = with stdenv.lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = https://www.freedesktop.org/wiki/Software/uchardet/;
    license = licenses.mpl11;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
