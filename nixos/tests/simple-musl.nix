import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { config, pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    #nixpkgs.pkgs = import ../.. {
    #  inherit (config.nixpkgs) config overlays;#  system;
    #  localSystem.config = "x86_64-unknown-linux-musl";
    #};
    nixpkgs.localSystem.config = "x86_64-unknown-linux-musl";

    #i18n.glibcLocales = pkgs.musl;
    #i18n.glibcLocales = (import (fetchTarball channel:nixos-unstable) {}).glibcLocales;
    i18n.glibcLocales = pkgs.musl;

    boot.initrd = {
      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.strace}/bin/strace
        copy_bin_and_libs ${pkgs.bash}/bin/bash
      '';
      extraUtilsCommandsTest = ''
        find $out
        ldd $out/bin/fsck
        ldd $out/bin/fsck.ext4

        $out/bin/systemd-udevd --help
        $out/bin/strace -V
      '';
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
