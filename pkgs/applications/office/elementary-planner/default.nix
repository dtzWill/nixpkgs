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
  version = "unstable-2020-02-27";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = "f79c1af6341e09f4e9b40e8ba64491fd86190c10";
    sha256 = "01zyx5yknjnxmw4yib4wxc0d45fl1r8bwfy06zwbyhxwci4048h6";
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

