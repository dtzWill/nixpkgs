{ stdenv, fetchurl, ncurses, lessSecure ? false }:

stdenv.mkDerivation rec {
  pname = "less";
  version = "561";

  src = fetchurl {
    url = "http://www.greenwoodsoftware.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0dlqzif8l743y46vpl3ggn7sjihk7628xhm0akf7ldszip4q6in2";
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
