{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.5.1";

  goPackagePath = "github.com/tdewolff/minify";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "17wjb2bjnzmsjn75a243mfllmg8s2xrq40m9dcwpr57wipn50rsx";
  };

  modSha256 = "09c3wyb7d3fq4kl280inahb9lyy7li8v4apa6r8y1hdyis19ymxk";

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = https://go.tacodewolff.nl/minify;
    platforms = platforms.all;
  };
}
