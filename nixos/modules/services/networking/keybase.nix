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

      mountDir = mkOption {
        type = types.nullOr types.str;
        default = "%h/keybase"; # null;
        description = ''
          Directory to mount kbfs, instead of
          <literal>$XDG_RUNTIME_DIR/keybase/kbfs</literal>.

          This directory should be different for each user.
        '';
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

    systemd.user.services.keybase = {
      wantedBy = [ "default.target" ];
    };
    systemd.user.services.kbfs = {
      wantedBy = [ "default.target" ];
      environment = {
        # Overrides value in user's config,
        # but explicit command-line parameter is always respected.
        # (which is only in `keybase`, not `kbfsfuse` used here)
        KEYBASE_MOUNTDIR = cfg.mountDir;
      };
    };

    systemd.packages = [ pkgs.keybase ];
    environment.systemPackages = [ pkgs.keybase ];

    environment.etc."keybase/config.json".text = builtins.toJSON {
      disable-root-redirector = true;
    };
  };
}
