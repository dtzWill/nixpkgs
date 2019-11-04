{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, python2, pkgconfig, libX11, libXext, xorgproto, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "libglvnd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libglvnd";
    #rev = "v${version}";
    rev = "58f1c0db95e060ae47faae9d556a48bf459558bd";
    sha256 = "0z5i806ih97y47wb6camp8siqh33m3d9nwkwi7xf7bcg3jw5s1n4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 addOpenGLRunpath ];
  buildInputs = [ libX11 libXext xorgproto ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/GLdispatch/Makefile.am \
      --replace "-Xlinker --version-script=$(VERSION_SCRIPT)" "-Xlinker"
  '';

  NIX_CFLAGS_COMPILE = [
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    # FHS paths are added so that non-NixOS applications can find vendor files.
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${addOpenGLRunpath.driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""

    "-Wno-error=array-bounds"
  ] ++ lib.optional stdenv.cc.isClang "-Wno-error";

  # Indirectly: https://bugs.freedesktop.org/show_bug.cgi?id=35268
  configureFlags  = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-tls";

  outputs = [ "out" "dev" ];

  # Set RUNPATH so that libGLX can find driver libraries in /run/opengl-driver(-32)/lib.
  # Note that libEGL does not need it because it uses driver config files which should
  # contain absolute paths to libraries.
  postFixup = ''
    addOpenGLRunpath $out/lib/libGLX.so
  '';

  passthru = { inherit (addOpenGLRunpath) driverLink; };

  meta = with stdenv.lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    homepage = https://github.com/NVIDIA/libglvnd;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
