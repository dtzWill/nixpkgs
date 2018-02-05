{ src ? ./default.nix }:
import src {
  localSystem = { config = "x86_64-unknown-linux-musl"; };
  config = { allowUnfree = false; };
}
