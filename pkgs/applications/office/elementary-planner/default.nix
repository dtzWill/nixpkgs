{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, appstream-glib, desktop-file-utils
, python3, vala, wrapGAppsHook
, evolution-data-server
, libunity
, libical
, libgee
, json-glib
, geoclue2
, sqlite
, libsoup
, gtk3
, pantheon /* granite, schemas */
, discount /* libmarkdown */
, gtksourceview3
, webkitgtk
, appstream
}:

stdenv.mkDerivation rec {
  pname = "planner";
  version = "unstable-2020-01-27";
  src = fetchFromGitHub {
    owner = "alainm23";
    repo = pname;
    rev = "e5f644d9d05a1da66d716dc4145786d23de2c672";
    #rev = version;
    sha256 = "0gydgqam2cfkp4zal2qfx9grx9hswqkrzrznjwd9dgxzan7h5rj2";
  };

  nativeBuildInputs = [
    appstream-glib
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
    libunity
    libical
    json-glib
    geoclue2
    sqlite
    libsoup
    gtk3
    libgee
    pantheon.granite
    discount
    gtksourceview3
    webkitgtk
    appstream
    pantheon.elementary-gsettings-schemas
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = https://github.com/alainm23/planner;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

