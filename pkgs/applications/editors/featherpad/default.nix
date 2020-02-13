{ mkDerivation, lib, fetchFromGitHub, pkgconfig, hunspell
, qmake, qttools, qtbase, qtsvg, qtx11extras }:

mkDerivation rec {
  version = "0.12.1";
  pname = "featherpad";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "12d48zp41nszfxqldfaj1fxg7426r25bipjajwv25pvgw3myvy7s";
  };
  nativeBuildInputs = [ qmake pkgconfig qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras hunspell ];
  meta = with lib; {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = https://github.com/tsujan/FeatherPad;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}
