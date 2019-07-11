{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.3";
  sha256 = "0gdnprc7gk4b7ckq8wbxbrj7i00r76r9a5g9mj7iln40512j0c0c";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
