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
  #version = "unstable-2019-11-14";
  version = "2.0.5";
  src = fetchFromGitHub {
    owner = "alainm23";
    repo = pname;
    #rev = "a11808a528cacb453fc945bcc1c382d8f4ecfcce";
    rev = version;
    sha256 = "0ddypdwknmdajvcy14q98g83iaqp28a6yy4m6i5gzgdb8px530ln";
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

