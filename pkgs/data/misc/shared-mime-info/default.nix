{stdenv, fetchurl, pkgconfig, gettext, perlPackages, itstool
, libxml2, glib}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "1.15";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/xdg/${pname}/uploads/b27eb88e4155d8fccb8bb3cd12025d5b/${pname}-${version}.tar.xz";
    sha256 = "146vynj78wcwdq0ms52jzm1r4m6dzi1rhyh3h4xyb6bw8ckv10pl";
  };

  nativeBuildInputs = [ pkgconfig gettext itstool ] ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [ libxml2 glib ];

  meta = with stdenv.lib; {
    inherit version;
    description = "A database of common MIME types";
    homepage = http://freedesktop.org/wiki/Software/shared-mime-info;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
