{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.8.1";
    sha256 = "122vvqwx1j0dw449ym6wisz24lp8kn3d529gdydxflcvjzkv4qry";
  }
