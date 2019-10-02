{ stdenv, fetchurl, fetchpatch, flex, bison }:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.9.1";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "153h1378diqyc27jjgz6gg5nxmb4ddk006d9xg69nqavgiikflk3";
  };

  nativeBuildInputs = [ flex bison ];

  # We need to force the autodetection because detection doesn't
  # work in pure build enviroments.
  configureFlags = [
    ("--with-pcap=" + {
      linux = "linux";
      darwin = "bpf";
    }.${stdenv.hostPlatform.parsed.kernel.name})
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    "ac_cv_linux_vers=2"
  ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace " -arch i386" ""
  '' + ''
    sed -i '1i#include <limits.h>' pcap-usb-linux.c
  '';

  patches = [
    # https://github.com/the-tcpdump-group/libpcap/pull/735
    (fetchpatch {
      name = "add-missing-limits-h-include-pr735.patch";
      url = https://github.com/the-tcpdump-group/libpcap/commit/aafa3512b7b742f5e66a5543e41974cc5e7eebfa.patch;
      sha256 = "05zb4hx9g24gx07bi02rprk2rn7fdc1ss3249dv5x36qkasnfhvf";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://www.tcpdump.org;
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
