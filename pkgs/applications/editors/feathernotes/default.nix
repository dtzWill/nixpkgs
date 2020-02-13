{ mkDerivation, lib, fetchFromGitHub, pkgconfig
, qmake, qttools, qtbase, qtsvg, qtx11extras }:

mkDerivation rec {
  version = "0.5.1";
  pname = "feathernotes";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherNotes";
    rev = "V${version}";
    sha256 = "0x67cirzgb9z2cxq8q1x6w25ff6j98srg8xs68c9s7pnd73bl4cr";
  };
  nativeBuildInputs = [ qmake pkgconfig qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras ];
  meta = with lib; {
    description = "Lightweight Qt5 Notes-Manager for Linux";
    homepage = https://github.com/tsujan/FeatherNotes;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}

