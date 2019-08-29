{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.22";
  #version = "2019-08-24";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     rev = version;
     #rev = "513f33c6a1185e0863131a81295ad9be242c6690";
     sha256 = "0dk4j1b8sy4j6w91cq5ga99f3hln9fgh79ayi9kvn8xgzksmhjdp";
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
