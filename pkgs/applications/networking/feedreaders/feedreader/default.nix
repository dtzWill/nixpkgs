{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig, vala, gettext, python3
, appstream-glib, desktop-file-utils, glibcLocales, wrapGAppsHook
, gtk3, libgee, libpeas, librest, webkitgtk, gsettings-desktop-schemas, hicolor-icon-theme
, curl, glib, glib-networking, gnome3, gst_all_1, json-glib, libnotify, libsecret, sqlite, gumbo, libxml2
}:

stdenv.mkDerivation rec {
  pname = "feedreader";
  version = "2.8.2-git";

  src = fetchFromGitHub {
    owner = "jangernert";
    repo = pname;
    #rev = "v${version}";
    rev = "1f8431bce62b292578bf5adac65e4788ef3ea87c";
    sha256 = "089lrmz3ip38wlc2xiapsdp0iifisspsxsr9v7gz0ih0n745afbl";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext appstream-glib desktop-file-utils
    libxml2 python3 wrapGAppsHook
  ];

  buildInputs = [
    curl glib glib-networking json-glib libnotify libsecret sqlite gumbo gtk3
    libgee libpeas gnome3.libsoup librest webkitgtk gsettings-desktop-schemas
    gnome3.gnome-online-accounts
    hicolor-icon-theme # for setup hook
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good
  ]);

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern desktop application designed to complement existing web-based RSS accounts";
    homepage = https://jangernert.github.io/FeedReader/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo worldofpeace ];
    platforms = platforms.linux;
  };
}
