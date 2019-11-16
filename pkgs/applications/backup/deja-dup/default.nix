{ stdenv, fetchFromGitLab, substituteAll, meson, ninja, pkgconfig, vala_0_40, gettext
, gnome3, libnotify, itstool, glib, gtk3, libxml2, gnome-online-accounts
, coreutils, libsecret, pcre, libxkbcommon, wrapGAppsHook
, libpthreadstubs, libXdmcp, epoxy, at-spi2-core, dbus, libgpgerror
, appstream-glib, desktop-file-utils, duplicity, json-glib, libsoup, packagekit
, hicolor-icon-theme # setup-hook
, glib-networking # needed previously
#, nautilus # for integration/extension
}:

stdenv.mkDerivation rec {
  pname = "deja-dup";
  version = "40.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "0x9z8z1mh1sxi28ilml3pvbc0g6ghcbyiy002rziwwlarxnbwkky";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace deja-dup/nautilus/NautilusExtension.c --subst-var-by DEJA_DUP_GSETTINGS_PATH $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';

  nativeBuildInputs = [
    meson ninja pkgconfig vala_0_40 gettext itstool
    appstream-glib desktop-file-utils libxml2 wrapGAppsHook
  ];

  buildInputs = [
   libnotify glib gtk3 libsecret
   pcre libxkbcommon libpthreadstubs libXdmcp epoxy gnome3.nautilus
   at-spi2-core dbus gnome-online-accounts libgpgerror
   json-glib glib-networking libsoup packagekit
  ];

  propagatedUserEnvPkgs = [ duplicity ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "A simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = https://wiki.gnome.org/Apps/DejaDup;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar joncojonathan ];
    platforms = platforms.linux;
  };
}
