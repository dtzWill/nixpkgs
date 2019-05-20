{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keybase;

in {

  ###### interface

  options = {

    services.keybase = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to start the Keybase service.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    #systemd.user.services.keybase = {
    #  description = "Keybase service";
    #  serviceConfig = {
    #    ExecStart = ''
    #      ${pkgs.keybase}/bin/keybase service --auto-forked
    #    '';
    #    Restart = "on-failure";
    #    PrivateTmp = true;
    #  };
    #  wantedBy = [ "default.target" ];
    #};

    systemd.user.services.keybase.enable = true;
    systemd.user.services.keybase-redirector.enable = true;
    systemd.user.services.kbfs.enable = true;

    systemd.packages = [ pkgs.keybase ];
    environment.systemPackages = [ pkgs.keybase ];
  };
}
