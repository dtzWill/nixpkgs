{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
#  version = "0.21";
  version = "2019-08-23";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     #rev = version;
     rev = "d9a2e5eb0e1f93d42f22e4cc3cd97d842e096555";
     sha256 = "054z96wgj5p1kvc63dnikcfsi2mk4fjx21sbn5pga3vph8gw32vq";
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
