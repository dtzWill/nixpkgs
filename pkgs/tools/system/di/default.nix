{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "di";
  version = "4.47.2";

  src = fetchurl {
    url = "http://gentoo.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1g97pp2hznskqlkhl6ppyzgdmv878bcqiwh633kdnm70d1pvh192";
  };

  makeFlags = [ "INSTALL_DIR=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Disk information utility; displays everything 'df' does and more";
    homepage = http://www.gentoo.com/di/;
    license = licenses.zlib;
    maintainers = with maintainers; [ manveru ndowens ];
    platforms = platforms.all;
  };
}
