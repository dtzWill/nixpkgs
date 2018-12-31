{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.2.7";

  goPackagePath = "github.com/errata-ai/vale";

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "06hk9kvi5jxhv9vfc9s7cs3iwqd8gcns6lmhvnwmhayypfjj2s25";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "Vale is an open source linter for prose";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
