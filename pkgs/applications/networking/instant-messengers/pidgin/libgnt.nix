{ stdenv, fetchhg, meson, ninja, pkgconfig, help2man,
glib, gobject-introspection, libxml2, ncurses
# lua
# python3
}:

stdenv.mkDerivation rec {
  pname = "libgnt";
  version = "unstable-2020-07-02";

  src = fetchhg {
    url = "https://keep.imfreedom.org/libgnt/libgnt";
    rev = "ac726721ef4f";
    sha256 = "127ik5flp222jh252j3d85q4pb5jz5ban20i5qw74jsrk1gfqzdk";
  };

  nativeBuildInputs = [ meson ninja pkgconfig help2man gobject-introspection ];
  buildInputs = [ glib libxml2 ncurses ];

  mesonFlags = [
    "-Ddoc=false"
  ];
}

	
