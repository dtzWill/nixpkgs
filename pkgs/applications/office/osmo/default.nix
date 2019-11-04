{ stdenv, fetchgit, pkgconfig, gtk3, libxml2, gettext, libical, libnotify
, libarchive, gspell, webkitgtk, libgringotts, wrapGAppsHook, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "osmo";
  version = "0.4.2-git";

  src = fetchgit {
    #url = "mirror://sourceforge/osmo-pim/${name}.tar.gz";
    url = "https://git.code.sf.net/p/osmo-pim/osmo";
    sha256 = "0gvcscnn441sm309h30simy4s4n83h2f01a7siaizspw4n9ldk1l";
  };

  nativeBuildInputs = [ pkgconfig gettext wrapGAppsHook autoreconfHook ];
  buildInputs = [ gtk3 libxml2 libical libnotify libarchive
    gspell webkitgtk libgringotts ];

  meta = with stdenv.lib; {
    description = "A handy personal organizer";
    homepage = http://clayo.org/osmo/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
