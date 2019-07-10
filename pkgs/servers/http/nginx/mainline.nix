{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.0";
  sha256 = "1aqgmrjzmklmv2iiyirk2h0hy35v1a76gczhjkxnms2krl35s6z2";
})

