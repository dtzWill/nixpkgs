{ stdenv, lib, fetchzip, pkgconfig, cmake, perlPackages, curl, gtest, lzma, bzip2, lz4
, db, dpkg, libxslt, docbook_xsl, docbook_xml_dtd_45
, gnutls

# used when WITH_DOC=ON
, w3m
, doxygen

# used when WITH_NLS=ON
, gettext

# opts
, withDocs ? true
, withNLS ? true
}:

stdenv.mkDerivation rec {
  name = "apt-${version}";

  version = "1.8.1";

  src = fetchzip {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/apt_${version}.tar.xz";
    sha256 = "1aldd7mmdf98lfglqgajdym1mxik6pqgshj4azi1hwsk4mhs2r2r";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    cmake perlPackages.perl curl gtest lzma bzip2 lz4 db dpkg libxslt.bin
    gnutls
  ] ++ lib.optionals withDocs [
    doxygen perlPackages.Po4a w3m docbook_xml_dtd_45
  ] ++ lib.optionals withNLS [
    gettext
  ];

  preConfigure = ''
    cmakeFlagsArray+=(
      -DBERKELEY_DB_INCLUDE_DIRS=${db.dev}/include
      -DDOCBOOK_XSL="${docbook_xsl}"/share/xml/docbook-xsl
      -DROOT_GROUP=root
      -DWITH_DOC=${if withDocs then "ON" else "OFF"}
      -DUSE_NLS=${if withNLS then "ON" else "OFF"}
    )
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "";
    homepage = https://launchpad.net/ubuntu/+source/apt;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
