{ stdenv, fetchurl, pkgconfig, gnum4, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "163s14d1rqp82gc1vsm3q0wzsbdicb9q6307kz0zk5lm6x9h5jmi";
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
