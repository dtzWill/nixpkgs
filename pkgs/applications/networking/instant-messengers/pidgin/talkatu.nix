{ stdenv, fetchhg,
meson, ninja, pkgconfig,
glib,
gobject-introspection,
gtk3,
gtkspell3,
gumbo,
cmark
}:

stdenv.mkDerivation {
  pname = "talkatu";
  version = "unstable-2019-11-07";

  src = fetchhg {
    url = "https://bitbucket.org/pidgin/talkatu";
    rev = "9f2390f06e9b";
    sha256 = "0rfcy7vj4bi08pfswmgidxzb5j0xwjhjzmffd448hdwlqp6ys8cb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    glib gobject-introspection
    gtk3 gtkspell3
    gumbo
    cmark
  ];
}
