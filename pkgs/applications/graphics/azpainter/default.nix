{ stdenv, fetchFromGitHub, autoreconfHook
, libX11, libXext, libXi
, freetype, fontconfig
, libpng, libjpeg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "azpainter";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "Symbian9";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0i5g67s4ysnvbaxmi7dhan0hfcfk8an14xykkafl47pqfx33npva";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libX11 libXext libXi
    freetype fontconfig
    libpng libjpeg
    zlib
  ];

  configureFlags = [
    "--with-freetype-dir=${stdenv.lib.getDev freetype}/include/freetype2"
  ];

  meta = with stdenv.lib; {
    description = "Full color painting software for illustration drawing";
    homepage = "https://osdn.net/projects/azpainter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
  };
}
