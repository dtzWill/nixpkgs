{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "exercism";
  version = "3.0.13";

  goPackagePath = "github.com/exercism/cli";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "17gvz9a0sn4p36hf4l77bxhhfipf4x998iay31layqwbnzmb4xy7";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
