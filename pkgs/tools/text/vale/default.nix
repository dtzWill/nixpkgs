{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.0.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "068973ayd883kzkxl60lpammf3icjz090nw07kfccvhcf24x07bh";
  };

  goPackagePath = "github.com/errata-ai/vale";

  modSha256 = "1cm9y4gk9m8af9sv11yv1qn8gw0h0q1207wrgfgiwr70f1hf2ls2";

  meta = with stdenv.lib; {
    homepage = https://errata-ai.github.io/vale/;
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
