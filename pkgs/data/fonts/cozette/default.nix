{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.6.3";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "1mn5xi3l5g9ary6d96lhhll149hc8z8kakc4qkmaqdlzn6g53y6j";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "13nmn846ycj9wb6jfky5d6h67yvajm3z4v1y5kcay6xalyr46bab";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "0zc0v1zzrqafd3ii7znxz5h0rnsv5vsrzxpg5sx0j53li2l64ymx";
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
