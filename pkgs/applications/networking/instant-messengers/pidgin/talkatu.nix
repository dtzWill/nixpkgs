{ stdenv, fetchhg,
meson, ninja, pkgconfig, help2man,
glib,
gobject-introspection,
gtk3,
gspell,
gumbo,
cmark,
xvfb_run,
}:

stdenv.mkDerivation {
  pname = "talkatu";
  version = "unstable-2019-11-07";

  src = fetchhg {
    url = "https://bitbucket.org/pidgin/talkatu";
    rev = "9f2390f06e9b";
    sha256 = "0rfcy7vj4bi08pfswmgidxzb5j0xwjhjzmffd448hdwlqp6ys8cb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection help2man xvfb_run ];
  buildInputs = [
    glib
    gtk3 gspell
    gumbo
    cmark
  ];

  mesonFlags = [ "-Ddoc=false" ];
}
