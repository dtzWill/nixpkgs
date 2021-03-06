{stdenv, pkgconfig, autoreconfHook, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "libspiro";
  version = "20190731";
  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libspiro";
    rev = version;
    sha256 = "1wc6ikjrvcq05jki0ligmxyplgb4nzx6qb5va277qiin8vad9b1v";
  };

  nativeBuildInputs = [pkgconfig autoreconfHook];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A library that simplifies the drawing of beautiful curves";
    homepage = https://github.com/fontforge/libspiro;
    license = licenses.gpl3Plus;
  };
}
