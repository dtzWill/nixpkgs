{ stdenv, fetchzip }:

let
  version = "17.0.1";
in fetchzip {
  name = "nextcloud-${version}";

  url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  #url = "https://download.nextcloud.com/server/prereleases/nextcloud-${version}.tar.bz2";

  sha256 = "1lixncsm032nnfild0gykhf4x42p8026cvikxwm5mjpisg7f171s";

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
