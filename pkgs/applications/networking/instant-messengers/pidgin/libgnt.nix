{ stdenv, fetchFromBitbucket, meson, ninja, pkgconfig, help2man,
glib, gobject-introspection, libxml2, ncurses
# lua
# python3
}:

stdenv.mkDerivation rec {
  pname = "libgnt";
  version = "unstable-2019-11-05";

  src = fetchFromBitbucket {
    owner = "pidgin";
    repo = "libgnt";
    rev = "88c07b4";
    sha256 = "1r333ad6mmhyyy3pahi0fshzd7x2xhq5ca3a4fkxc0p8bw9dnl7c";
  };

  nativeBuildInputs = [ meson ninja pkgconfig help2man gobject-introspection ];
  buildInputs = [ glib libxml2 ncurses ];

  mesonFlags = [
    "-Ddoc=false"
  ];
}

	
