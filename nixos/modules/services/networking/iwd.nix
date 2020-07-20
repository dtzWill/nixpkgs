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
      type = types.str;
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
          EAP.MTU = 1400;
          EAPoL.MaxHandshakeTime = 5;
          General = {
            # Enable/Disable iwd internal dhcp client
            EnableNetworkConfiguration = false; # true;
            # UseDefaultInterface = true;

            AddressRandomization = "once";

            #control_port_over_nl80211 = true;
            ControlPortOverNL80211 = true;
            #roam_rssi_threshold = -70;
            RoamThreshold = -70;
            # Default behavior is only available if this is NOT set
            # (either true or false)-- see docs.
            #use_default_interface = true;

            #
            # Explicitly enforce/disable management frame protection
            #
            # 0 - Disable management frame protection
            # 1 - Set management frame protection capable (default)
            # 2 - Management frame protection required
            #
            #management_frame_protection = 1;
            ManagementFrameProtection = 1;

            #
            # Enable/disable ANQP queries. The way IWD does ANQP queries is dependent on
            # a recent kernel patch. If your kernel does not have this functionality this
            # should be disabled (default). Some drivers also do a terrible job of sending
            # public action frames (freezing or crashes) which is another reason why this
            # has been turned off by default. All aside, if you want to connect to Hotspot
            # 2.0 networks ANQP is most likely going to be required (you may be able to
            # pre-provision to avoid ANQP).
            #
            #disable_anqp = true;
            DisableANQP = true;
            #
            # Control the behavior of MAC address randomization by setting the
            # mac_randomize option.  iwd supports the following options:
            #   "default" - Lets the kernel assign a mac address from the permanent mac
            #   address store when the interface is created by iwd.  Alternatively,
            #   if the 'use_default_interface' is set to true, then the mac address is
            #   not touched.
            #   "once" - MAC address is randomized once when iwd starts.  If
            #   'use_default_interface' is set to true, only the interface(s) managed
            #   by iwd will be randomized.
            #
            # One can control which part of the address is randomized using
            # mac_randomize_bytes option.  iwd supports the following options:
            #   "nic" - Randomize only the NIC specific octets (last 3 octets).  Note that
            #   the randomization range is limited to 00:00:01 to 00:00:FE.  The permanent
            #   mac address of the card is used for the initial 3 octets.
            #   "full" - Randomize the full 6 octets.  The locally-administered bit will
            #   be set.
            #
            #mac_randomize = "default";
            #mac_randomize_bytes = "full";
          };
          Network = {
            # DNS helper to use: resolvconf or systemd
            # Default to systemd-resolved service
            NameResolvingService = "resolvconf";
          };
          Scan = {
            DisablePeriodicScan = false;
            DisableRoamingScan = false;
          };
          # TODO: BSS blacklist settings

          Rank = {
            #
            # Manually specify a 5G ranking factor. 5G networks are already preferred but
            # only in terms of calculated data rate, which is RSSI dependent. This means it
            # is still possible for IWD to prefer a 2.4GHz AP in the right conditions.
            # This ranking provides a way to further weight the ranking towards 5G if
            # required. Also, a lower 5G factor could be used to weight 2.4GHz if that is
            # desired. The default is 1.0, which does not affect the calculated ranking.
            #
            #rank_5g_factor = "1.0"; # XXX: why aren't floats/doubles handled automatically?
            BandModifier5Ghz = "1.0";
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

    hardware.firmware = [ pkgs.wireless-regdb ];

    systemd.packages = [ pkgs.iwd ];

    # hopefully merges with existing service nicely?
    systemd.services.iwd = {
      wantedBy = [ "multi-user.target" ];
      ## wants = [ "network.target" ];
      ## before = [ "network.target" "multi-user.target" ];
      ## after = [
      ##   "systemd-udevd.service" "network-pre.target"
      ##   #"sys-subsystem-net-devices-${cfg.interface}.device"
      ## ];
      ## #requires = [ "sys-subsystem-net-devices-${cfg.interface}.device" ];
      serviceConfig.ExecStart = [
        "" # empty, reset upstream value
        iwdCmd
      ];
    };

    environment.etc."iwd/main.conf".text = generators.toINI {} cfg.mainConfig;
  };

  meta.maintainers = with lib.maintainers; [ mic92 dtzWill ];
}
