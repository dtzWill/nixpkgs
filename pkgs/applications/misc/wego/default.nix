{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "wego-${version}";
  version = "20190211-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "994e4f141759a1070d7b0c8fbe5fad2cc7ee7d45";
  
  goPackagePath = "github.com/schachmat/wego";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/schachmat/wego";
    sha256 = "1affzwi5rbp4zkirhmby8bvlhsafw7a4rs27caqwyj8g3jhczmhy";
  };

  goDeps = ./deps.nix;

  meta = {
    license = stdenv.lib.licenses.isc;
  };
}
