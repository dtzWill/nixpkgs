{ fetchurl, substituteAll, stdenv, pkgconfig, gnome3, gettext, gobject-introspection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, ninja, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, gsettings-desktop-schemas, glib, gtk3, gnome-desktop
, geocode-glib, pipewire, libgudev, libwacom, xwayland, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
#, sysprof
, desktop-file-utils
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.32.2";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h577i2ap7dpfy1jg101jvc6nzccc0csgvd55ahydlr8f94frcva";
  };

  mesonFlags = [
    "-Dxwayland-path=${xwayland}/bin/Xwayland"
    "-Dinstalled_tests=false" # TODO: enable these
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [
    meson
    pkgconfig
    gettext
    ninja
    python3
    # for cvt command
    xorgserver
    wrapGAppsHook
    desktop-file-utils
  ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon pipewire xwayland
    gnome-settings-daemon #sysprof
  ];

  patches = [
   # TODO: submit upstream
   # ./0001-build-use-get_pkgconfig_variable-for-sysprof-dbusdir.patch
    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
    # Fix build with libglvnd provided headers
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/a444a4c5f58ea516ad3cd9d6ddc0056c3ca9bc90.patch";
      sha256 = "0imy2j8af9477jliwdq4jc40yw1cifsjjf196gnmwxr9rkj0hbrd";
    })
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "mutter";
      attrPath = "gnome3.mutter";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
