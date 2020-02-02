{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext, boost }:

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.37";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1b0vd0h49kjg4nxjfjrcg8gzplz93ryr6xyfha2pvhlrzdd2d1lj";
  };

  buildInputs = [ glib ncurses mpd_clientlib boost ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  mesonFlags = [
    "-Dlirc=disabled"
    "-Dregex=disabled"
    "-Ddocumentation=disabled"
  ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = https://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
