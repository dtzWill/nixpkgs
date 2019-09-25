{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "google-fonts";
  version = "unstable-2019-09-25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "5d5a98fe6bf1aa81c0943233f1fbfe470e66ba29";
    sha256 = "15iz9f1d15fkgyvpqrrkr4l8z3ak21h5rf630rhbgava9grhm7dr";
  };

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

    # See comment above, the structure of these is a bit odd
    # We keep the ofl/<font>/static/ variants
    rm -rv ofl/comfortaa/*.ttf \
      ofl/mavenpro/*.ttf \
      ofl/muli/*.ttf \
      ofl/oswald/*.ttf

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
