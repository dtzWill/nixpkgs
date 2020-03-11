{ stdenv, cmake, fetchFromGitHub, bctoolbox, belr }:

stdenv.mkDerivation rec {
  baseName = "belcard";
  version = "4.3.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0xgkpb2spwymidfaqngkin6jsrsjzgi2kcyvs2jci8f5qkb08kdc";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib;{
    description = "Belcard is a C++ library to manipulate VCard standard format";
    homepage = https://github.com/BelledonneCommunications/belcard;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
