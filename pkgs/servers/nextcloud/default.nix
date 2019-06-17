{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nextcloud-${version}";
  version = "16.0.1";
in fetchzip {
  name = "nextcloud-${version}";

  url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  sha256 = "1z8095v59hrx34b7zq9bp1ddpr3imiya9ad9jr92i6q4jp5p9i5g";

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
