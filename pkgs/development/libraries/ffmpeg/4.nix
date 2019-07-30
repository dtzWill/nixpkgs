{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.4";
  sha256 = "1qd7a10gs12ifcp31gramcgqjl77swskjfp7cijibgyg5yl4kw7i";
  patches = [(fetchpatch { # remove on update
    name = "fix-hardcoded-tables.diff";
    url = "http://git.ffmpeg.org/gitweb/ffmpeg.git/commitdiff_plain/c8232e50074f";
    sha256 = "0jlksks4fjajby8fjk7rfp414gxfdgd6q9khq26i52xvf4kg2dw6";
  })];
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
