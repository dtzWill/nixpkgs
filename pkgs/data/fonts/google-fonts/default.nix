{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "google-fonts-${version}";
  version = "2019-05-21";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "e5feaac92dc0b37e169876315fe3973519fc9c0b";
    sha256 = "19zv7nnql0pmvy17jcvsqjzd5xd2n9rxil35x5y6453xihg0qrll";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1rf33m68qvjw7ycp0xibjc3nacmxfal8vbcxa4ydv6rpdd84rgxi";

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    # These directories need to be removed because they contain
    # older or duplicate versions of fonts also present in other
    # directories. This causes non-determinism in the install since
    # the installation order of font files with the same name is not
    # fixed.
    rm -rv ofl/alefhebrew \
      ofl/misssaintdelafield \
      ofl/mrbedford \
      ofl/siamreap \
      ofl/terminaldosislight

    # Remove 'static' versions of variable fonts, avoid conflict
    rm ofl/*/static -rf

    if find . -name "*.ttf" | sed 's|.*/||' | sort | uniq -c | sort -n | grep -v '^.*1 '; then
      echo "error: duplicate font names"
      exit 1
    fi
  '';

  installPhase = ''
    dest=$out/share/fonts/truetype
    find . -name '*.ttf' -exec install -m 444 -Dt $dest '{}' +
  '';

  meta = with stdenv.lib; {
    homepage = https://fonts.google.com;
    description = "Font files available from Google Fonts";
    license = with licenses; [ asl20 ofl ufl ];
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = with maintainers; [ manveru ];
  };
}
