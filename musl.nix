{ src ? ./default.nix }:
import src { localSystem = (import ./lib).systems.examples.musl64; config = { allowUnfree = false; }; }
