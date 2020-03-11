{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.28";
  version = "unstable-2020-03-02";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     #rev = version;
     rev = "07b792306fed881af9f12f5052f375240c70b1b3";
     sha256 = "06jlspd9y7qc3jg2kim65p5b4b9nzgwyyhmxypgyxk8br9vgrxwr";
  };

  patches = [
    ./fix-dbus-tests.patch
    ./export-rtnl.patch
    ./regen-sym-for-rtnl.patch
    ./and-ascii_table.patch
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
    #"--enable-debug"
    #"--enable-asan"
    #"--enable-ubsan"
  ];
  #separateDebugInfo = true;
  #dontStrip = true; # leave

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
