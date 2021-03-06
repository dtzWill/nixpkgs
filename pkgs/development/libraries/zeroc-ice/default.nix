{ stdenv, fetchFromGitHub, mcpp, bzip2, expat, openssl, db5
, darwin, libiconv, Security
}:

stdenv.mkDerivation rec {
  name = "zeroc-ice-${version}";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "05xympbns32aalgcfcpxwfd7bvg343f16xpg6jv5s335ski3cjy2";
  };

  patches = [ ./makefile.patch ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=class-memaccess" ];

  prePatch = lib.optional stdenv.isDarwin ''
    substituteInPlace Make.rules.Darwin \
        --replace xcrun ""
  '';

  postUnpack = ''
    sourceRoot=$sourceRoot/cpp
  '';

  prePatch = ''
    substituteInPlace config/Make.rules.Darwin \
        --replace xcrun ""
  '';

  makeFlags = [ "prefix=$(out)" "OPTIMIZE=yes" ];

  # cannot find -lIceXML (linking bin/transformdb)
  #enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.zeroc.com/ice.html;
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
