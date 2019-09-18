{ stdenv, fetchurl, cmake, webkitgtk, libwpe, wpebackend-fdo, glib }:

stdenv.mkDerivation rec {
  pname = "cog";
  version = "0.3.91";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1y7fvzik7jzz2khz5cwksgnlch6fszjsysw4my9a9fa1pisv1hcr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libwpe wpebackend-fdo webkitgtk glib ];
}
