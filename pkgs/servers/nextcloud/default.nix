{ stdenv, fetchzip }:

let
  version = "17.0.10";
in fetchzip {
  name = "nextcloud-${version}";

  url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  #url = "https://download.nextcloud.com/server/prereleases/nextcloud-${version}.tar.bz2";

  sha256 = "02dcyinjfq4w8wqvx50smhz6a0rhzaa255dcfin72fnw1brcag9s";

  # Maybe fix resourcelocator webroot issue, courtesy of comment on upstream issue 13556
  # XXX: Unsure if also useful/needed (?): https://gist.github.com/kesselb/d035c4a7334b155143686466370bc1eb
  extraPostFetch = ''
    patch -p0 -d $out -i ${./webroot.patch}
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
