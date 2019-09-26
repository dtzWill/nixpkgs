{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "apr";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://apache/apr/${pname}-${version}.tar.bz2";
    sha256 = "1spp6r2a3xcl5yajm9safhzyilsdzgagc2dadif8x6z9nbq4iqg2";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./is-this-a-compiler-bug.patch ];

  # This test needs the net
  postPatch = ''
    rm test/testsock.*
  '';

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  configureFlags =
    [ "--with-installbuilddir=${placeholder "dev"}/share/build" ]
    # Including the Windows headers breaks unistd.h.
    # Based on ftp://sourceware.org/pub/cygwin/release/libapr1/libapr1-1.3.8-2-src.tar.bz2
    ++ stdenv.lib.optional (stdenv.hostPlatform.system == "i686-cygwin") "ac_cv_header_windows_h=no";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.eelco ];
  };
}
