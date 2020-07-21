{ stdenv, fetchFromGitHub
, vala, meson, ninja, pkgconfig, python3, libgee, gsettings-desktop-schemas
, gnome3, pantheon, gobject-introspection, wrapGAppsHook
, gtk3, json-glib, glib, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "tootle";
  version = "unstable-2020-07-16";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    #rev = version;
    rev = "418ee90ea1bc48c2bd1f8c362a79a7e81432b6e1";
    sha256 = "1drziyyhd4hhs79sqr8b4vnkln50mwg8d7a7iampz6pzx3qkzqd0";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3 pantheon.granite json-glib glib glib-networking
    libgee gnome3.libsoup gsettings-desktop-schemas
  ];

  #patches = [
  #  # Fix build with Vala 0.46
  #  # https://github.com/bleakgrey/tootle/pull/164
  #  (fetchpatch {
  #    url = "https://github.com/worldofpeace/tootle/commit/0a88bdad6d969ead1e4058b1a19675c9d6857b16.patch";
  #    sha256 = "0xyx00pgswnhxxbsxngsm6khvlbfcl6ic5wv5n64x7klk8rzh6cm";
  #  })
  #];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Simple Mastodon client designed for elementary OS";
    homepage = https://github.com/bleakgrey/tootle;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
