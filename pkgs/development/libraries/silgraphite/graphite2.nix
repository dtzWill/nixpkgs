{ stdenv, fetchurl, pkgconfig, cmake
, buildWithDepsUsuallyDisabledToAvoidCycle ? false
, freetype, harfbuzz
 }:

stdenv.mkDerivation rec {
  version = "1.3.13";
  pname = "graphite2";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/${pname}-${version}.tgz";
    sha256 = "01jzhwnj1c3d68dmw15jdxly0hwkmd8ja4kw755rbkykn1ly2qyx";
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
