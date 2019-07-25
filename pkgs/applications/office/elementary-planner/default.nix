{ stdenv, fetchFromGitHub
, meson, ninja
, evolution-data-server
, libunity
, libical
, libgee
, json-glib
, geoclue2
, sqlite
, libsoup
, gtk3
, pantheon /* granite */
}:

stdenv.mkDerivation rec {
  pname = "planner";
  src = fetchFromGitHub {
    owner = "alainm23";
    repo = pname;
  };

  nativeBuildInputs = [
    meson
    ninja
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
  ];

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = https://github.com/alainm23/planner;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

