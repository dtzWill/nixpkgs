{ lib, fetchFromGitHub }:

let
  pname = "victor-mono";
  version = "1.2.6";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rubjo";
  repo = pname;
  rev = "v${version}";

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # The github source usually contains a copy of this
  # in `public/VictorMonoAll.zip` but 1.2.6 didn't update this.
  # Looks like the ttf files were regenerated, use those for now.
  # (following no longer applies, but hopefully does soon)
  ## # Happily, tagged releases on github contain the same
  ## # file `VictorMonoAll.zip` as from the website,
  ## # so we extract it from the tagged release.
  ## # Both methods produce the same file, but this way
  ## # we can safely reason about what version it is.
  postFetch = ''
    mkdir -p $out/share/fonts/{true,open}type/${pname}

    tar xvf $downloadedFile -C $out/share/fonts/truetype/${pname} --strip-components=3 --wildcards --no-wildcards-match-slash \*/src/assets/\*.ttf
  '';

  sha256 = "120fvsy2pisv9ffasxmzlglq5qsm7xm4jkckjhkcsyq65714v6cc";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}

