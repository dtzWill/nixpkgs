{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.6.2";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "0hq86r3rxcnr6hkr8l30fwq81zq37f0n16jj4g3bifqk77md1s4v";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "08sbbsl2y8ap0ailps4kbsiac1l0v28dygi34qk9qn9jy8q8hhvb";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "1mjh55hlb29qwswzyynpdqg0c6ni5svfsgy9pfjacrxn02ym9kdz";
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
