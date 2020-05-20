{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "562";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "06vhzpqfd25znfpdyqpp62f6kz60a89rp90sai0j84r8r73p1d7a";
  };

  configureFlags = [ "--sysconfdir=/etc" ] # Look for ‘sysless’ in /etc.
    ++ stdenv.lib.optional lessSecure [ "--with-secure" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = http://www.greenwoodsoftware.com/less/;
    description = "A more advanced file pager than ‘more’";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ eelco dtzWill ];
  };
}
