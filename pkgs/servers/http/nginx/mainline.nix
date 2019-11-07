{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.5";
  sha256 = "1hqhziic4csci8xs4q8vbzpmj2qjkhmmx68zza7h5bvmbbhkbvk3";
})

