{ stdenv, fetchurl, meson, ninja, pkgconfig
, gettext, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  pname = "gst-rtsp-server";
  version = "1.16.2";

  meta = with stdenv.lib; {
    description = "Gstreamer RTSP server";
    homepage    = "https://gstreamer.freedesktop.org";
    longDescription = ''
      a library on top of GStreamer for building an RTSP server.
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bkchr ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0vn23nxwvs96g7gcxw5zbnw23hkhky8a8r42wq68411vgf1s41yy";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja gettext gobject-introspection pkgconfig ];

  buildInputs = [ gst-plugins-base gst-plugins-bad ];

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];
}
