{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.4";
  sha256 = "0mg521bxh8pysmy20x599m252ici9w97kk7qy7s0wrv6bqv4p1b2";
})

