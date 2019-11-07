{ stdenv, fetchzip }:

let
  version = "17.0.1";
in fetchzip {
  name = "nextcloud-${version}";

  #url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";

  # eep, quick kludge that can be replaced when 17.0.1 is actually tagged
  url = "https://github.com/nextcloud/server/archive/version/${version}/final.tar.gz";
  sha256 = "0fjnivmsxq08qv5ch73vnj7vpjdwshlr91rrsx2q7lwr8pdrsd9b";

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
