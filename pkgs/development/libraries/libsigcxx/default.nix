{ stdenv, fetchurl, pkgconfig, gnum4, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "01pdp25d7sm79rsz7n4n3wjb92lkc7hdp278zx260vmj3rf8b82h";
  };

  nativeBuildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://libsigcplusplus.github.io/libsigcplusplus/;
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
