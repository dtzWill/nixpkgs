{ config, lib, pkgs, ... }:

let
  cfg = config.services.trilium-server;
in
{

  options.services.trilium-server = with lib; {
    enable = mkEnableOption "trilium-server";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/trilium";
      example = "/var/lib/trilium";
      description = ''
        The directory storing the nodes database and the configuration.
      '';
    };

    instanceName = mkOption {
      type = types.str;
      default = "Trilium";
      example = "Trilium";
      description = ''
        Instance name used to distinguish between different instances
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
      description = ''
        The host address to bind to (defaults to localhost).
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      example = 8080;
      description = ''
        The port number to bind to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ kampka ];

    users.groups.trilium = {};
    users.users.trilium = {
      description = "Trilium User";
      group = "trilium";
      home = cfg.dataDir;
      isSystemUser = true;
    };

    systemd.services = {
      trilium-server-setup = let 
        configIni = pkgs.writeText "trilium-config.ini" ''
          [General]
          # Instance name can be used to distinguish between different instances
          instanceName=${cfg.instanceName}

          # Disable automatically generating desktop icon
          noDesktopIcon=true

          [Network]
          # host setting is relevant only for web deployments - set the host on which the server will listen
          host=${cfg.host}
          # port setting is relevant only for web deployments, desktop builds run on random free port
          port=${toString cfg.port}
          # true for TLS/SSL/HTTPS (secure), false for HTTP (unsecure).
          https=false
        '';
      in {
          wantedBy = [ "multi-user.target" ];
          before = [ "trillium-server.service" ];
          script = ''
            mkdir -p ${cfg.dataDir}
            chown -R trilium:trilium ${cfg.dataDir}
            ln -sf ${configIni} ${cfg.dataDir}/config.ini
          '';
          serviceConfig.Type = "oneshot";
      };

      trilium-server = {
          wantedBy = [ "multi-user.target" ];
          wants = [ "trillium-server-setup.service" ];
          after = [ "trillium-server-setup.service" ];
          script = ''
            export TRILIUM_DATA_DIR="${cfg.dataDir}"
            exec ${pkgs.trilium-server}/bin/trilium-server
          '';
          serviceConfig.User = "trilium";
          serviceConfig.Group = "trilium";
          serviceConfig.PrivateTmp = "true";
      };
    };
  };
}
