{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, python, gst-plugins-base, libxml2
, flex, perl, gettext, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-editing-services";
  version = "1.16.1";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1las94jkx83sxmzi5w6b0xm89dqqwzpdsb6h9w9ixndhnbpzm8w2";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobject-introspection python flex perl ];

  propagatedBuildInputs = [ gst-plugins-base libxml2 ];

  mesonFlags = [
    "-Dgtk_doc=disabled"
  ];

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  postPatch = ''
    sed -i -r -e 's/p(bad|good) = .*/p\1 = pbase/' tests/check/meson.build
  '';
}
