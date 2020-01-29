{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "554";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0a86ms9zfwvq705x72d4y754b2qm95kmfdjga4djnjc9xb5vmwxq";
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
