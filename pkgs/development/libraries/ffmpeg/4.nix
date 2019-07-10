{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.4";
  sha256 = "1qd7a10gs12ifcp31gramcgqjl77swskjfp7cijibgyg5yl4kw7i";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
