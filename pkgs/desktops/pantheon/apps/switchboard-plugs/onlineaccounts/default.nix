{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala
, libgee, granite, gtk3, libaccounts-glib, libsignon-glib, json-glib
, librest, webkitgtk, libsoup, switchboard, glib-networking }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
  #  rev = version;
    rev = "96c57ced630a9062dcd6238bf7dd4e9facc70436";
    sha256 = "1x2cyhdpzdnkn9mrf46lld0ya4q2rw754kh3qvz27b2rf5fxc0p6";
  };

  patches = [ ./wdtz-ify.patch ];

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    json-glib
    glib-networking
    libaccounts-glib
    libgee
    libsignon-glib
    libsoup
    librest
    switchboard
    webkitgtk
  ];

  PKG_CONFIG_LIBACCOUNTS_GLIB_PROVIDERFILESDIR = "${placeholder "out"}/share/accounts/providers";
  PKG_CONFIG_LIBACCOUNTS_GLIB_SERVICEFILESDIR = "${placeholder "out"}/share/accounts/services";
  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";


  meta = with stdenv.lib; {
    description = "Switchboard Online Accounts Plug";
    homepage = https://github.com/elementary/switchboard-plug-onlineaccounts;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
