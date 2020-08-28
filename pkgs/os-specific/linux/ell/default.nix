{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  #version = "0.32";
  version = "unstable-2020-08-26";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     #rev = version;
     rev = "87c76bbc85fe286925cbdb53d733fc9f9fd2ed12";
     sha256 = "14y613yvv2qsnsyj1cr6kdqk9gkw9d9zwdkjsmi5k493wmgkjnfr";
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
