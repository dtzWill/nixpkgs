{ stdenv, fetchgit, intltool, pkgconfig, gtk2, gpgme, libgpgerror, libassuan, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gpa";
  # 0.10.0 + fixes :(
  version = "unstable-2019-05-13";

  src = fetchgit {
    url = "git://git.gnupg.org/gpa.git";
    rev = "1cb82dcfcea46878cad353022c8f537d4c9d879d";
    sha256 = "1rmd4g3hbz30hdlhfhz96k4jc977f0kviyjfx84dl0vpbdr0xjdq";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig ];
  buildInputs = [ gtk2 gpgme libgpgerror libassuan ];

  meta = with stdenv.lib; {
    description = "Graphical user interface for the GnuPG";
    homepage = https://www.gnupg.org/related_software/gpa/;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
