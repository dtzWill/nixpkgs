{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.7";
  sha256 = "1zwiqljhzf0ym6r3hrg6k2qfb2mxi7i0lpafg4xnkr875225c9xn";
})

