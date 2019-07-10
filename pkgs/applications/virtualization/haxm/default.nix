{ stdenv, fetchFromGitHub, linuxHeaders, nasm }:

# TODO: this builds kernel modules so needs to be moved there
# Also module directory needs overriding, probably common
stdenv.mkDerivation rec {
  pname = "haxm";
  version = "7.5.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    rev = "v${version}";
    sha256 = "164c6y5n90c30bsdvsihmwmr20n352yzmxx378gdcdzhg3wi5vwl";
  };

  nativeBuildInputs = [ nasm ];
  buildInputs = [ linuxHeaders ];

  makeFlags = [ "-C" "platforms/linux" ];

  meta.broken = true; # not finished packaging yet
}
