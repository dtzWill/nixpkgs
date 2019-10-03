{stdenv, fetchurl, pkgconfig, gettext, perlPackages, itstool
, libxml2, glib}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info";
  version = "1.14";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/xdg/${pname}/uploads/aee9ae9646cbef724bbb1bd2ba146556/${pname}-${version}.tar.xz";
    sha256 = "09jayi3i2xgx4mmb70pl86c129691dwy9rchp5w9hri3wk5fjwy5";
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
