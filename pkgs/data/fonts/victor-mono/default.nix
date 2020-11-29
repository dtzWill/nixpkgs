{ lib, fetchFromGitHub }:

let
  pname = "victor-mono";
  version = "1.4.2";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "rubjo";
  repo = pname;
  rev = "v${version}";

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # Happily, tagged releases on github contain the same
  # file `VictorMonoAll.zip` as from the website,
  # so we extract it from the tagged release.
  # Both methods produce the same file, but this way
  # we can safely reason about what version it is.
  postFetch = ''
    tar xvf $downloadedFile --strip-components=2 ${pname}-${version}/public/VictorMonoAll.zip

    mkdir -p $out/share/fonts/{true,open}type/${pname}

    unzip -j VictorMonoAll.zip \*.ttf -d $out/share/fonts/truetype/${pname}
    unzip -j VictorMonoAll.zip \*.otf -d $out/share/fonts/opentype/${pname}
  '';

  sha256 = "0y5f1ba24czs3r2rvyanvbjrg9l0v5ns94g6xq5pscsfih5869dk";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}

