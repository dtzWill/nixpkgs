{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.27";
  version = "unstable-2020-01-27";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     # rev = version;
     rev = "2ca0f82e54379b7ee7e6b6e6ee37ab4f73173e24";
     sha256 = "06gi6gqnqypcabq4xck730hx2lwnfwwi7mln9k02a83p8zwnfrrm";
  };

  patches = [
    ./fix-dbus-tests.patch
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
    "--enable-asan"
    "--enable-ubsan"
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
