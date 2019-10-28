{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.25";
  version = "2019-10-28";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     #rev = version;
     rev = "4fe7283fef9d288cdddb534f0aaf9f294a7cd5a9";
     sha256 = "1bj2s2izgkx5qv67lk09w75iw5dc41djjzc21h3kdgfydfr2bmhm";
  };

  patches = [
    ./fix-dbus-tests.patch
    ./dont-index-adj-objs.patch
    ./check.patch
    ./memmove.patch
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
