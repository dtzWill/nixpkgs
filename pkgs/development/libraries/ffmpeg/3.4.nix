{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (rec {
  version = branch;
  branch = "3.4.6";
  sha256 = "0gmqbhg5jjcfanrxrl657zn12lzz73sfs8xwryfy7n9rn6f2fwim";
  darwinFrameworks = [ Cocoa CoreMedia ];
} // args)
