{ stdenv, fetchurl, buildPerlPackage, perl, DBI, sqlite }:

buildPerlPackage {
  pname = "DBD-SQLite";
  version = "1.64";

  src = fetchurl {
    url = mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.64.tar.gz;
    sha256 = "00gz5aw3xrr92lf9nfk0dhmy7a8jzmxhznddd9b0a8w4a1xqzbpl";
  };

  propagatedBuildInputs = [ DBI ];
  buildInputs = [ sqlite ];

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  makeMakerFlags = "SQLITE_INC=${sqlite.dev}/include SQLITE_LIB=${sqlite.out}/lib";

  postInstall = ''
    # Get rid of a pointless copy of the SQLite sources.
    rm -rf $out/${perl.libPrefix}/*/*/auto/share
  '';

  meta = with stdenv.lib; {
    description = "Self Contained SQLite RDBMS in a DBI Driver";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
  };
}
