{ stdenv, fetchurl, pkgconfig, cmake
, buildWithDepsUsuallyDisabledToAvoidCycle ? false
, freetype, harfbuzz
 }:

stdenv.mkDerivation rec {
  version = "1.3.12";
  name = "graphite2-${version}";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/${name}.tgz";
    sha256 = "1l1940d8fz67jm6a0x8cjb5p2dv48cvz3wcskwa83hamd70k15fd";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = stdenv.lib.optionals buildWithDepsUsuallyDisabledToAvoidCycle [ freetype harfbuzz ];

  patches = [ ./graphite2-1.2.0-cmakepath.patch ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  doCheck = false; # fontTools

  meta = with stdenv.lib; {
    description = "An advanced font engine";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
