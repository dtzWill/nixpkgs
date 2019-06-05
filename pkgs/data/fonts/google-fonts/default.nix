{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "google-fonts-${version}";
  version = "2019-06-04";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "87776223497b72be361b5c08ba16e9c659209f37";
    sha256 = "1n93dbk5fy8wi487ibyi1xp46r3hl58ymgib8f7f7gnbf0hvkrx1";
  };

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0mx8yvdxrb2wxr0y1vrl5h76dz5mi770vdfb9hrykx0v1wz5g47h";

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
