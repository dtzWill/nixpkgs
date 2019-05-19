{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.wireless.iwd;

  iwdCmd = [ "${pkgs.iwd}/libexec/iwd" ]
    ++ optional cfg.debug "-d"
    ++ optional cfg.dbusDebug "-B";
in {
  options.networking.wireless.iwd = {
    enable = mkEnableOption "iwd";
    debug = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run iwd with debugging enabled (-d)
      '';
    };
    dbusDebug = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run iwd with dbus debugging enabled (-B)
      '';
    };

    # XXX: This is bad and I should feel bad.  But fixes issue for now.
    interface = mkOption {
      type = types.string;
      description = ''
        Name of interface name to bind to the .device of.
        Not actually passed to iwd, but used to ensure
        predictable interface renaming is completed
        before iwd manages an interface.  Probably.
      '';
    };

    mainConfig = mkOption {
        type = types.attrsOf types.attrs;
        default = {
          EAP.mtu = 1400;
          EAPoL.max_4way_handshake_time = 5;
          General = {
            ControlPortOverNL80211 = true;
            roam_rssi_threshold = -70;
            # Default behavior is only available if this is NOT set
            # (either true or false)-- see docs.
            #use_default_interface = true;
          };
          Scan = {
            disable_periodic_scan = false;
            disable_roaming_scan = false;
            disable_mac_address_randomization = false;
          };
          # TODO: BSS blacklist settings
          # TODO: Rank settings

          Rank = {
            rank_5g_factor = 1.0;
          };
        };
        description = "settings to write to /etc/iwd/main.conf";
    };
  };

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
      wants = [ "network.target" ];
      before = [ "network.target" "multi-user.target" ];
      after = [
        "systemd-udevd.service" "network-pre.target"
        #"sys-subsystem-net-devices-${cfg.interface}.device"
      ];
      #requires = [ "sys-subsystem-net-devices-${cfg.interface}.device" ];
      serviceConfig.ExecStart = [
        "" # empty, reset upstream value
        iwdCmd
      ];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/iwd 0700 root root -"
    ];

    environment.etc."iwd/main.conf".text = generators.toINI {} cfg.mainConfig;
  };

  meta.maintainers = with lib.maintainers; [ mic92 dtzWill ];
}
