{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, python3, libgee, gsettings-desktop-schemas
, gnome3, pantheon, gobject-introspection, wrapGAppsHook
, gtk3, json-glib, glib, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "tootle";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bleakgrey";
    repo = pname;
    #rev = version;
    rev = "1e42721faa04d3be2dc9ac09f1421ae7f3e72278";
    sha256 = "16l1xhxqm9wm9mjjlqs88135hxskz0d320jdlsfn968nsplj01nw";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    pantheon.vala
    wrapGAppsHook
  ];
  buildInputs = [
    gtk3 pantheon.granite json-glib glib glib-networking
    libgee gnome3.libsoup gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x ./meson/post_install.py
    patchShebangs ./meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Simple Mastodon client designed for elementary OS";
    homepage    = https://github.com/bleakgrey/tootle;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
