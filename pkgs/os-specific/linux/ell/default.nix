{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.25";
  #version = "2019-10-23";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     rev = version;
     #rev = "0914606bb89cf55e02b60b150867b53876bea968";
     sha256 = "1x3riqpjcn2m7nalzgmdfd67nxkfxzk4hdwmwanpycpkp1y7y1w5";
  };

  patches = [
    ./fix-dbus-tests.patch
    ./dont-index-adj-objs.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
  ];

  checkInputs = [
    dbus
  ];

  enableParallelBuilding = true;

  doCheck = true;
  enableParallelChecking = false;

  configureFlags = [
    "--enable-debug"
    #"--enable-asan"
    #"--enable-ubsan"
  ];
  #separateDebugInfo = true;
  dontStrip = true; # leave

  meta = with stdenv.lib; {
    homepage = https://01.org/ell;
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
