{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.6.1";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "1cbr55ppjpcc1d08scfbvk9kd8swb2g73n83xd8wca0gxbcqhx8z";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "08rld9dkypm5djbjg0ncrap2fh3jh1c6cxs0lnrbrrzhp39d4i7i";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "1cvb3811pzvk8f2127x54727yv9a73zybp255nbzyybqhykjjczb";
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
