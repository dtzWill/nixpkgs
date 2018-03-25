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

    boot.initrd.extraUtilsCommandsTest = ''
      find $out
      ldd $out/bin/fsck
      ldd $out/bin/fsck.ext4

      $out/bin/systemd-udevd --help
    '';
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
