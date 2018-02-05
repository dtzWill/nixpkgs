{ src ? ./default.nix }:
import src {
  crossSystem = { config = "x86_64-unknown-linux-musl"; };
  config = { allowUnfree = false; };
}
