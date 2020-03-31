{ stdenv, fetchurl, fetchgit, pkgconfig, libdrm, libpciaccess, cairo, pixman, udev, xorgproto
, libX11, libXext, libXv, libXrandr, glib, bison, libunwind, python3, kmod, json_c, docutils
, procps, utilmacros, gtk-doc, openssl, peg, meson, ninja, elfutils, flex, liboping }:

stdenv.mkDerivation rec {
  pname = "intel-gpu-tools";
  version = "1.25";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/igt-gpu-tools-${version}.tar.xz";
    sha256 = "04fx7xclhick3k7fyk9c4mn8mxzf1253j1r0hrvj9sl40j7lsia0";
  };

  nativeBuildInputs = [ pkgconfig utilmacros meson ninja flex ];
  buildInputs = [ libdrm libpciaccess cairo pixman xorgproto udev libX11 kmod
    libXext libXv libXrandr glib bison libunwind python3 procps
    gtk-doc openssl peg elfutils json_c docutils liboping ];

  mesonFlags = [
    "-Ddocs=disabled" # requires building tests, shrug
    "-Dman=enabled"
    "-Dvalgrind=disabled"
    "-Dchamelium=disabled"
  ];

  postPatch = ''
    patchShebangs tests

    patchShebangs debugger/system_routine/pre_cpp.py

    patchShebangs lib/i915/perf-configs/perf-codegen.py

    patchShebangs man/rst2man.sh
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://01.org/linuxgraphics/";
    description = "Tools for development and testing of the Intel DRM driver";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ pSub ];
  };
}
