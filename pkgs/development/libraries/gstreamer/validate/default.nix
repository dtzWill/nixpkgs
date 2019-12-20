{ stdenv, fetchurl, pkgconfig, gstreamer, gst-plugins-base
, python, gobject-introspection, json-glib
}:

stdenv.mkDerivation rec {
  pname = "gst-validate";
  version = "1.16.2";

  meta = {
    description = "Integration testing infrastructure for the GStreamer framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1jpfrzg3yc6kp66bgq3jy14xsj3x71mk2zh0k16yf0326awwqqa8";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig gobject-introspection
  ];

  buildInputs = [
    python json-glib
  ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  enableParallelBuilding = true;

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
  ];
}
