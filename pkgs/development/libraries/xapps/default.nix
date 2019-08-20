{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig
, glib, gtk3, gtksourceview3, libpeas, libxml2
, gobject-introspection, gspell
, libgnomekbd, vala, python3
}:

let
  py = python3.withPackages (ps: with ps; [ pygobject3 ]);
in stdenv.mkDerivation rec {
  pname = "xapps";
  #version = "master.mint19"; # not sure if stable
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = "refs/tags/${version}";
    #rev = "refs/tags/master.mint19";
    sha256 = "1lnbm8dhrc0k4d9v0zxngcdxwmsr9bd0lfm8i81xgpbsdg75la25";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala ];

  buildInputs = [ glib gtk3 gtksourceview3 libpeas libxml2 gobject-introspection gspell libgnomekbd py ];
}

