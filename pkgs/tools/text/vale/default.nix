{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.7.1";

  goPackagePath = "github.com/errata-ai/vale";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "1qi3brjppiymk6as0xic2n3bhq8g8qw1z8d9a24w60x9gp52yq5m";
  };

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
