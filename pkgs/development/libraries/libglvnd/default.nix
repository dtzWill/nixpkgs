{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, python2, pkgconfig, libX11, libXext, xorgproto, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "libglvnd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "0my5b8z8shwlfmirdl8bgds4p1pmjjiw44lh6s81nd3jrjjx5gm7";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 addOpenGLRunpath ];
  buildInputs = [ libX11 libXext xorgproto ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/GLX/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
    substituteInPlace src/EGL/Makefile.am \
      --replace "-Wl,-Bsymbolic " ""
  '';

  NIX_CFLAGS_COMPILE = [
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    # FHS paths are added so that non-NixOS applications can find vendor files.
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${addOpenGLRunpath.driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""
  ] ++ lib.optional stdenv.cc.isClang "-Wno-error";

  # Indirectly: https://bugs.freedesktop.org/show_bug.cgi?id=35268
  configureFlags  = stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-tls";

  outputs = [ "out" "dev" ];

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    addOpenGLRunpath $out/lib/libGLX.so $out/lib/libEGL.so
  '';

  passthru = { inherit (addOpenGLRunpath) driverLink; };

  meta = with stdenv.lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    homepage = https://github.com/NVIDIA/libglvnd;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
