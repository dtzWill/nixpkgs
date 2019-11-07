{ stdenv, fetchFromGitHub, linuxHeaders, nasm }:

# TODO: this builds kernel modules so needs to be moved there
# Also module directory needs overriding, probably common
stdenv.mkDerivation rec {
  pname = "haxm";
  version = "7.5.4";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    rev = "v${version}";
    sha256 = "09ibfhfp3095hr6sl3a2iha9g7qxkzn14xps6jd1g5mcv55gsf9b";
  };

  nativeBuildInputs = [ nasm ];
  buildInputs = [ linuxHeaders ];

  makeFlags = [ "-C" "platforms/linux" ];

  meta.broken = true; # not finished packaging yet
}
