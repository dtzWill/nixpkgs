{ pkgs, lib, ... }:

with lib;

{
  # Musl
  #nixpkgs.localSystem.config = "x86_64-unknown-linux-musl";
  nixpkgs.localSystem = lib.systems.examples.musl64;
  i18n.glibcLocales = pkgs.musl; # blah
  boot.initrd = {
    extraUtilsCommands = ''
      for BIN in ${pkgs.utillinux}/bin/*; do
        copy_bin_and_libs $BIN
      done
    '';
  };
}
