{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.thermald;
in {
  ###### interface
  options = {
    services.thermald = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable thermald, the temperature management daemon.
        '';
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable debug logging.
        '';
      };

      # TODO: make 'log-level' option or something
      info = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable info logging.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "the thermald manual configuration file.";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.thermald ];
    services.dbus.packages = [ pkgs.thermald ];

    users.groups.power = {};

    systemd.services.thermald = {
      description = "Thermal Daemon Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.thermald}/sbin/thermald \
            --no-daemon \
            ${optionalString cfg.debug "--loglevel=debug"} \
            ${optionalString cfg.info "--loglevel=info"} \
            ${optionalString (cfg.configFile != null) "--config-file ${cfg.configFile}"} \
            --dbus-enable
        '';
        Type = "dbus";
        BusName = "org.freedesktop.thermald";
        SuccessExitStatus = 1;
      };
    };
  };
}
