{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.16.2";
    sha256 = "1n5lbnxsbymjqlwrazcbnh7r5rpr8qp5mzgmm3kxqncjbrwigg3c";
  }
