import ./make-test.nix ({ pkgs, ...} : {
  name = "xfce";

  machine =
    { pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.auto.enable = true;
      services.xserver.displayManager.auto.user = "alice";

      services.xserver.desktopManager.xfce.enable = true;

      hardware.pulseaudio.enable = true; # needed for the factl test, /dev/snd/* exists without them but udev doesn't care then

      virtualisation.memorySize = 1024;
    };

  testScript =
    ''
      $machine->waitForX;
      $machine->waitForFile("/home/alice/.Xauthority");
      $machine->succeed("xauth merge ~alice/.Xauthority");
      $machine->waitForWindow(qr/xfce4-panel/);
      $machine->sleep(10);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl -p /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 xfce4-terminal &'");
      $machine->waitForWindow(qr/Terminal/);
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';
})
