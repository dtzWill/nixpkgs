{ pkgs, lib, ... }:

with lib;

{
  # Musl
  nixpkgs.localSystem.config = "x86_64-unknown-linux-musl";
  i18n.glibcLocales = pkgs.musl; # blah
  boot.initrd = {
    extraUtilsCommands = ''
      for BIN in ${pkgs.utillinux}/bin/*; do
        copy_bin_and_libs $BIN
      done
    '';
  };
}
