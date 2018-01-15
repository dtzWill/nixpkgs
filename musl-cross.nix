{ src ? ./default.nix }:
import src { crossSystem = (import ./lib).systems.examples.musl64; config = { allowUnfree = false; }; }

