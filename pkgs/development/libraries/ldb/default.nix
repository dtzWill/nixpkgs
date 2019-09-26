{ stdenv, fetchurl, python, pkgconfig, which, readline, tdb, talloc, tevent, lmdb
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42, cmocka
}:

stdenv.mkDerivation rec {
  pname = "ldb";
  version = "2.0.7";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1z3bghjh3c94rlgqma1vpgakhzhxcrq8k4s6lb0f51nj4cg6qvjg";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig which python docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [
    readline tdb talloc tevent popt lmdb
    libxslt python
    cmocka
  ];

  preConfigure = ''
    patchShebangs buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  stripDebugList = "bin lib modules";

  meta = with stdenv.lib; {
    description = "A LDAP-like embedded database";
    homepage = https://ldb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
