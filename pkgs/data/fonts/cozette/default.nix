{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.7.2";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "0kmb34vnzm40p1db1swzbm1165ix142n1vdjfxs5320np5w1bgmj";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "0v5lapd3a2mb6i6qk9w4b61ddbi5fpfgn5i57skk4a8dcxqp4c4a";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "00zlaw6swvlydqc83jlnwzn83kjzqfi09f340jm68kvlpcrlb031";
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
