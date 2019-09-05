{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.cri-o;
in
{
  options.virtualisation.cri-o = {
    enable = mkEnableOption "Container Runtime Interface for OCI (CRI-O)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cri-o runc ];

    systemd.services.crio = {
      description = "Container Runtime Interface for OCI (CRI-O)";
      documentation = [ "https://github.com/cri-o/cri-o" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.cri-o}/bin/crio";
        ExecReload = "/bin/kill -s HUP $MAINPID";
        Environment = "GOTRACEBACK=crash";
        TasksMax = "infinity";
        LimitNOFILE = "1048576";
        LimitNPROC = "1048576";
        LimitCORE = "infinity";
        OOMScoreAdjust = "-999";
        TimeoutStartSec = "0";
        Restart = "on-abnormal";
      };
    };
  };
}
