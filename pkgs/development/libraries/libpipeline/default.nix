{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libpipeline-1.5.2";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "1ysrn22ixd4nmggy6f7qcsm7waadmlbg2i0n9mh6g7dfq54wcngx";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with stdenv.lib; {
    homepage = http://libpipeline.nongnu.org;
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
