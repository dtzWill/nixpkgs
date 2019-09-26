{ stdenv, fetchurl, python, wafHook, which, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  pname = "tdb";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0jh0iqbb6pkvqrqn033w5g6gwa4bdgkvp49z0qpkk3h2wk6b4h4h";
  };

  nativeBuildInputs = [ pkgconfig wafHook python which docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [
    readline libxslt python
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "The trivial database";
    longDescription = ''
      TDB is a Trivial Database. In concept, it is very much like GDBM,
      and BSD's DB except that it allows multiple simultaneous writers
      and uses locking internally to keep writers from trampling on each
      other. TDB is also extremely small.
    '';
    homepage = https://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
