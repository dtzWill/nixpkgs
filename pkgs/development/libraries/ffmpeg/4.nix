{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.2.1";
  sha256 = "1m5nkc61ihgcf0b2wabm0zyqa8sj3c0w8fi6kr879lb0kdzciiyf";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
