{ fetchFromGitHub, lib }:

with lib;
let
  # 2018-01-13
  oe-core = fetchFromGitHub {
    owner = "openembedded";
    repo = "openembedded-core";
    rev = "5cf92ca436e1a1ba60fec8b30b6cb3cfd4842bc8";
    sha256 = "1f06y0l6jd3h74jcbqnmd06d09mmx686n9i2w0bjqn4xjmihs36w";
  };

  # *.patch from this directory
  dir = oe-core + "/meta/recipes-core/systemd/systemd";
  content =  builtins.readDir dir;
  patchFilter = n:
    builtins.match ".*\\.patch" n != null &&
    # don't include this path
    n != "0007-use-lnr-wrapper-instead-of-looking-for-relative-opti.patch";
  patchNames = filter patchFilter (attrNames content);
  patches = map (p : dir + "/" + p) patchNames;

in patches
