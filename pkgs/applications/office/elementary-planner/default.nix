{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, desktop-file-utils
, python3, vala, wrapGAppsHook
, evolution-data-server
, libical
, libgee
, json-glib
, glib
, sqlite
, libsoup
, gtk3
, pantheon /* granite, icons, maintainers */
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "elementary-planner";
  version = "unstable-2020-02-06";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = "4a8952cf02c79d109f1558d30e8c11e6aae06db4";
    sha256 = "16wjy5d89xhg0akfxr7clkdkn3y3yfinxmr8ad59x8ssc2rncj6k";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    libical
    libgee
    json-glib
    glib
    sqlite
    libsoup
    gtk3
    pantheon.granite
    webkitgtk
    pantheon.elementary-icon-theme
  ];

  patches = [
    ./dont-force-elementary-themes.patch
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ] ++ pantheon.maintainers;
  };
}

