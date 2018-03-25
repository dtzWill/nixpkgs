import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { config, pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    boot.initrd = {
      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.strace}/bin/strace
        copy_bin_and_libs ${pkgs.bash}/bin/bash
      '';
        #copy_bin_and_libs ${pkgs.utillinux}/bin/*
      extraUtilsCommandsTest = ''
        find $out
        ldd $out/bin/fsck
        ldd $out/bin/fsck.ext4

        $out/bin/systemd-udevd --help
      '';
        #$out/bin/strace -V

      kernelModules = [ "ext4" ];
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
