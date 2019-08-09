{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.8.0";
    sha256 = "1914i1hm59adbv8jzn46cvf9pmcvs1gclkm95f4rkdgafqimaywr";
  }
