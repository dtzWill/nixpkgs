{ stdenv, cmake, fetchFromGitHub, bctoolbox }:

stdenv.mkDerivation rec {
  baseName = "belr";
  version = "4.3.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0lsd6dc64ygjz5k1cm088vl78f3qlw43bnfrf239afglkxp0h0m9";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib;{
    description = "Belr is Belledonne Communications' language recognition library";
    homepage = https://github.com/BelledonneCommunications/belr;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
