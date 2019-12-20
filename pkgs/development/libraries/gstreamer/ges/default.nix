{ stdenv, fetchurl, fetchpatch, meson, ninja
, pkgconfig, python, gst-plugins-base, libxml2
, flex, perl, gettext, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gstreamer-editing-services";
  version = "1.16.2";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "05hcf3prna8ajjnqd53221gj9syarrrjbgvjcbhicv0c38csc1hf";
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
