{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.wireless.iwd;
in {
  options.networking.wireless.iwd.enable = mkEnableOption "iwd";

  config = mkIf cfg.enable {
    assertions = [{
      assertion = !config.networking.wireless.enable || config.networking.connman.enable;
      message = ''
        Only one wireless daemon is allowed at the time: networking.wireless.enable and networking.wireless.iwd.enable are mutually exclusive.
      '';
    }];

    # for iwctl
    environment.systemPackages =  [ pkgs.iwd ];

    services.dbus.packages = [ pkgs.iwd ];

    #systemd.packages = [ pkgs.iwd ];

    # hopefully merges with existing service nicely?
    systemd.services.iwd = {
      wantedBy = [ "multi-user.target" ];
      before = [ "network.target" "multi-user.target" ];
      after = [ "systemd-udevd.service" "network-pre.target" ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/iwd 0700 root root -"
    ];
  };

  meta.maintainers = with lib.maintainers; [ mic92 ];
}
