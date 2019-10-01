{ stdenv, fetchzip }:

let
  version = "17.0.0";
in fetchzip {
  name = "nextcloud-${version}";

  url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  sha256 = "14k8j52fh51p4i9i1y8miikww0mdmrpcd1mla6arks80rfm6lfc9";

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
