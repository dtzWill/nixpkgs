{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "google-fonts";
  version = "unstable-2020-02-05";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "5050dd268f0e06faf74360fb4147814a44eedc2a";
    sha256 = "18icf9jhkix87n3mc1qbkwb9b4fs4r9bxbv1ra8yw89fs6kg06mk";
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
