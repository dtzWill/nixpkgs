{ stdenv
, fetchFromGitHub
, scfbuild
, variant ? "color" # "color" or "black"
}:

let
  filename = builtins.replaceStrings
    [ "color"              "black"              ]
    [ "OpenMoji-Color.ttf" "OpenMoji-Black.ttf" ]
    variant;

in stdenv.mkDerivation rec {
  pname = "openmoji";
  version = "12.0.0-git";

  src = fetchFromGitHub {
    owner = "hfg-gmuend";
    repo = pname;
    #rev = version;
    rev = "dca677501aceb368a39002436cf9b9be47e264b7";
    sha256 = "0vp3daf1bkd83h4ih8jhpn16z35cqwnpbx9yj708qyqg8gz0lrs6";
  };

  nativeBuildInputs = [
    scfbuild
  ];

  # Some id and data-* attributes in the svg files contain unicode characters,
  # which scfbuild (a python2 program) does not like
  # (https://github.com/13rac1/scfbuild/issues/14).
  # Fortunately, it's only metadata which we can remove:
  postPatch = ''
    sed -Ei 's/(id|data-[^=]*)="[^"]*"//g' black/svg/*.svg color/svg/*.svg
  '';

  buildPhase = ''
    # Bash reimplementation of helpers/export-svg-font.js
    # so we don't need to build all the node deps first
    hexcodes=()
    missingGlyphBlack='./black/svg/25A1.svg'
    missingGlyphColor='./color/svg/25A1.svg'
    for f in ./color/svg/*.svg; do
      basename=$(basename "$f" .svg)
      hexcodes+=(''${basename//-/ })
      filename=$(basename "$f");
      cp "./color/svg/$filename" "./font/tmp-color/$filename"
      cp "./black/svg/$filename" "./font/tmp-black/$filename"
    done

    hexcodes=($(uniq<<<"$hexcodes"))

    for h in $hexcodes; do
      filename="$h.svg"
      if [ ! -e "./color/svg/$filename" ]; then
        echo "$h is missing -> substitute with \"Missing Glyph\": $filename"
        cp $missingGlyphColor "./font/tmp-color/$filename"
        cp $missingGlyphBlack "./font/tmp-black/$filename"
      fi
    done

    # Actually build the font:
    cd font
    scfbuild -c scfbuild-${variant}.yml
  '';

  installPhase = ''
    install -Dm644 ${filename} $out/share/fonts/truetype/${filename}
  '';

  meta = with stdenv.lib; {
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    homepage = "https://openmoji.org/";
    downloadPage = "https://github.com/hfg-gmuend/openmoji/releases";
    description = "Open-source emojis for designers, developers and everyone else";
  };
}

