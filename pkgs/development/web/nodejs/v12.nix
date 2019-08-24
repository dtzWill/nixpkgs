{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.9.0";
    sha256 = "1ia178ln79r0w592gnl06rxmdv1dgaxnx52xvcffan6z3fxfhpz0";
  }
