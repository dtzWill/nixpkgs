{ stdenv, fetchFromBitbucket, meson, ninja, pkgconfig, help2man,
glib, gobject-introspection, gtk3, vala,
# lua
# python3
}:

stdenv.mkDerivation rec {
  pname = "gplugin";
  version = "0.29.0";

  src = fetchFromBitbucket {
    owner = "gplugin";
    repo = "gplugin";
    rev = "v${version}";
    sha256 = "0z1ra80w50nnxk1pninmhh46s0rrzcmbrx0d9l3inr136cn7a9nv";
  };

  nativeBuildInputs = [ meson ninja pkgconfig help2man gobject-introspection vala ];
  buildInputs = [ glib gtk3 ];

  mesonFlags = [
    "-Ddoc=false"
    # plugin loaders
    "-Dlua=false"
    "-Dpython=false"
  ];
}
