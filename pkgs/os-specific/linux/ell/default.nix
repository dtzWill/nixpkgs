{ stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
#  version = "0.22";
  version = "2019-09-17";

  outputs = [ "out" "dev" ];

  src = fetchgit {
     url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
     #rev = version;
     rev = "e54ed93c00d2f7e5a35ddebb0ff8f8ad3027e14e";
     sha256 = "0y836fcvpvj57fwcb0sacza49mxlzdffjvvj9a84mxv2ra6z71cd";
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
