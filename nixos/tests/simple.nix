import ./make-test.nix ({ pkgs, ...} : {
  name = "simple";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { config, pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    boot.initrd.extraUtilsCommandsTest = ''
      find $out
      ldd $out/bin/fsck
      ldd $out/bin/fsck.ext4
    '';
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("multi-user.target");
      $machine->shutdown;
    '';
})
