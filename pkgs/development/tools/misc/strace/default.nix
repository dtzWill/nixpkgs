{ stdenv, fetchurl, perl, libunwind, buildPackages }:

stdenv.mkDerivation rec {
  name = "strace-${version}";
  version = "5.2";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${name}.tar.xz";
    sha256 = "1li49i75wrdw91hchyyd8spnzfcmxcfyfb5g9zbaza89aq4bq4ym";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = stdenv.lib.optional libunwind.supportsHost libunwind; # support -k

  configureFlags = stdenv.lib.optional (!stdenv.hostPlatform.isx86) "--enable-mpers=check";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://strace.io/;
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
  };
}
