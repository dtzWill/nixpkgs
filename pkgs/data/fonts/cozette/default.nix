{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.8.0";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "1zw33w9nvg7lr1llqqzm0gf8h2gzrj8bhm86zwkb92pyrz4c7a7r";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "0vrrxzbic2jf7528xlfvr7xrhcfxgsvch5p23zwh98qs1wypv32m";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "0x05jkynbv4bkq4z8gs2dhhsbz7a0mp9vrv7caqjpwp0sd58xkll";
    }
  ];

  nativeBuildInputs = [ mkfontscale ];

  sourceRoot = "./";

  unpackCmd = ''
    otName=$(stripHash "$curSrc")
    cp $curSrc ./$otName
  '';

  installPhase = ''

    install -D -m 644 *.otf -t "$out/share/fonts/opentype"
    install -D -m 644 *.ttf -t "$out/share/fonts/truetype"
    install -D -m 644 *.otb -t "$out/share/fonts/misc"

    mkfontdir "$out/share/fonts/misc"
    mkfontscale "$out/share/fonts/truetype"
    mkfontscale "$out/share/fonts/opentype"
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    description = "A bitmap programming font optimized for coziness.";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons ];
  };
}
