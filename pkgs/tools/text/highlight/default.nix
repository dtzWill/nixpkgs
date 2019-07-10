{ stdenv, fetchurl, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "highlight";
  version = "3.51";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${pname}-${version}.tar.bz2";
    sha256 = "15x4m548bhr7yx27i73iysm5fir6g08djniyy1yj4r1kzny1xfk9";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optional stdenv.isDarwin  gcc ;

  # TODO: gui! (qt, make optional)
  buildInputs = [ getopt lua boost ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=${placeholder "out"}"
    "conf_dir=${placeholder "out"}/etc/highlight"
  ];

  meta = with stdenv.lib; {
    description = "Source code highlighting tool";
    homepage = http://www.andre-simon.de/doku/highlight/en/highlight.php;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ndowens willibutz ];
  };
}
