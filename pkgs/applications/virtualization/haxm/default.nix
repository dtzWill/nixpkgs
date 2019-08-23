{ stdenv, fetchFromGitHub, linuxHeaders, nasm }:

# TODO: this builds kernel modules so needs to be moved there
# Also module directory needs overriding, probably common
stdenv.mkDerivation rec {
  pname = "haxm";
  version = "7.5.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jhkygg4plpz2c7i5xmj1k9nk1sh7g994bkyd9nzw7crv2y9y93l";
  };

  nativeBuildInputs = [ nasm ];
  buildInputs = [ linuxHeaders ];

  makeFlags = [ "-C" "platforms/linux" ];

  meta.broken = true; # not finished packaging yet
}
