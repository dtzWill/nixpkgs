{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.2";
  sha256 = "1mgcxm7sqkajx35px05szsmn9mawwm03cfpmk3br7bcp3a1i0gq2";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
