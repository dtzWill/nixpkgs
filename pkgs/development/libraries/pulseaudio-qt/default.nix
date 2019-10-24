{ lib, mkDerivation, fetchFromGitHub, extra-cmake-modules, kdoctools, libpulseaudio }:

mkDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1k1xayskyd8ky3lbgvlym3vhwfpc95gcps07bzvd1hixpw5g95sn";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [ libpulseaudio ];
}
