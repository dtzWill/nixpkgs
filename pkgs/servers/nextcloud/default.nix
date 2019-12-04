{ stdenv, fetchzip }:

let
  version = "17.0.1";
in fetchzip {
  name = "nextcloud-${version}";

  url = "https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2";
  #url = "https://download.nextcloud.com/server/prereleases/nextcloud-${version}.tar.bz2";

  sha256 = "1yc40rjcjfdws1kdb4zfbpx71n7618w2q8pxz5j71qizcv7bgqmj";

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
