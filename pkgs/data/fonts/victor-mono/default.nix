{ lib, fetchFromGitHub }:

let
  pname = "victor-mono";
  version = "1.2.6";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "rubjo";
  repo = pname;
  #rev = "v${version}";
  rev = "68b7add39c619c96f0394b82b51f113501b55c77"; # 1.2.6, dist was generated after tag

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # Happily, tagged releases on github contain the same
  # file `VictorMonoAll.zip` as from the website,
  # so we extract it from the tagged release.
  # Both methods produce the same file, but this way
  # we can safely reason about what version it is.
  postFetch = ''
    tar xvf $downloadedFile --strip-components=2 ${pname}-${rev}/public/VictorMonoAll.zip

    mkdir -p $out/share/fonts/{true,open}type/${pname}

    unzip -j VictorMonoAll.zip \*.ttf -d $out/share/fonts/truetype/${pname}
    unzip -j VictorMonoAll.zip \*.otf -d $out/share/fonts/opentype/${pname}
  '';

  sha256 = "0dqwz2acc2ipbdc136vvan56gfp9vfwfkf95k6y7cz5w1jx69ywn";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}

