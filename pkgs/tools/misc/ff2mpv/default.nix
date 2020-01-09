{ stdenv, fetchFromGitHub, python3, mpv }:

stdenv.mkDerivation rec {
  pname = "ff2mpv";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "dfd25c4a2dab23fae299894e342a58b35d6116ba";
    sha256 = "0mj7rm2ai3lwd0m7nhvvjzn6b5si9phca6lja35awpg81s9xc60s";
  };

  dontBuild = true;

  buildInputs = [ python3 /* so patchShebangs sees it, I guess */ ];

  installPhase = ''
    substituteInPlace ff2mpv.json \
      --replace '/home/william/scripts/ff2mpv' \
                '${placeholder "out"}/bin/ff2mpv'
    install -Dt $out/lib/mozilla/native-messaging-hosts ff2mpv.json

    install -Dm755 -T ff2mpv.py $out/bin/ff2mpv
    patchShebangs $out/bin/ff2mpv
    substituteInPlace $out/bin/ff2mpv --replace "'mpv'" "'${mpv}/bin/mpv'"
  '';
}
