{ stdenv, lib, fetchgit, meson, ninja, pkgconfig, mrsh }:

stdenv.mkDerivation rec {
  pname   = "imrsh";
  version = "2020-01-24";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/imrsh";
    rev = "fd5f2506aa18afda6c5a160b3b2cd56d755df145";
    sha256 = "0h3y8n2myqkdjxjh8f3id9iqpw050ks8mlvlw79z4nikvsyx1nxc";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ mrsh ];

  meta = with stdenv.lib; {
    description = "Interactive POSIX shell based on mrsh";
    homepage = "https://git.sr.ht/~sircmpwn/imrsh";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
