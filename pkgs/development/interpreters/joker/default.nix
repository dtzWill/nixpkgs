{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "joker-${version}";
  version = "0.14.0";

  goPackagePath = "github.com/candid82/joker";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1b38alajxs89a9x3f3ldk1nlynp6j90qhl1m2c6561rsm41sqfz0";
  };

  preBuild = "go generate ./...";

  postBuild = "rm go/bin/sum256dir";

  dontInstallSrc = true;

  excludedPackages = "gen"; # Do not install private generators.

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/candid82/joker;
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
