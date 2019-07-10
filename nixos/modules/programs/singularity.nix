{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.singularity;
  singularity = pkgs.singularity.overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      mv ''${!outputBin}/libexec/singularity/bin/starter-suid ''${!outputBin}/libexec/singularity/bin/starter-suid.orig
      ln -s /run/wrappers/bin/singularity-suid ''${!outputBin}/libexec/singularity/bin/starter-suid
    '';
  });
in {
  options.programs.singularity = {
    enable = mkEnableOption "Singularity";
  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ singularity ];
      security.wrappers.singularity-suid.source = "${getBin singularity}/libexec/singularity/bin/starter-suid.orig";
      systemd.tmpfiles.rules = [
        "d /var/singularity/mnt/session 0770 root root -"
        "d /var/singularity/mnt/final 0770 root root -"
        "d /var/singularity/mnt/overlay 0770 root root -"
        "d /var/singularity/mnt/container 0770 root root -"
        "d /var/singularity/mnt/source 0770 root root -"
      ];
  };

}
