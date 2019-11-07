{ stdenv, fetchzip }:

let
  version = "17.0.1RC1";
in fetchzip {
  name = "nextcloud-${version}";

  # url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  url = "https://download.nextcloud.com/server/prereleases/nextcloud-${version}.tar.bz2";

  sha256 = "0ivpzqdbbbbvzhg0ns6wdhrgvhbkmz85sffdk7ff13kn67i5slxw";

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
