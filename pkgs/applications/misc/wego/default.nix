{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "wego";
  version = "unstable-2017-04-03";
  rev = "415efdfab5d5ee68300bf261a0c6f630c6c2584c";
  
  goPackagePath = "github.com/schachmat/wego";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/schachmat/wego";
    sha256 = "1affzwi5rbp4zkirhmby8bvlhsafw7a4rs27caqwyj8g3jhczmhy";
  };

  goDeps = ./deps.nix;

  meta = {
    license = stdenv.lib.licenses.isc;
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
  };
}
