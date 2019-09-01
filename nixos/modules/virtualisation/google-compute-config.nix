{ config, lib, pkgs, ... }:
with lib;
let
  gce = pkgs.google-compute-engine;
in
{
  imports = [
    ../profiles/headless.nix
    ../profiles/qemu-guest.nix
  ];


  fileSystems."/" = {
    fsType = "ext4";
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
  };

  boot.growPartition = true;
  boot.kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
  boot.initrd.kernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [ "virtio_pci" "virtio_net" ];

  # Generate a GRUB menu.  Amazon's pv-grub uses this to boot our kernel/initrd.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
  services.openssh.passwordAuthentication = mkDefault false;

  # Use GCE udev rules for dynamic disk volumes
  services.udev.packages = [ gce ];

  # Force getting the hostname from Google Compute.
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  environment.systemPackages = [ pkgs.cryptsetup ];

  # Make sure GCE image does not replace host key that NixOps sets
  environment.etc."default/instance_configs.cfg".text = lib.mkDefault ''
    [InstanceSetup]
    set_host_keys = false
  '';

  # Rely on GCP's firewall instead
  networking.firewall.enable = mkDefault false;

  # Configure default metadata hostnames
  networking.extraHosts = ''
    169.254.169.254 metadata.google.internal metadata
  '';

  networking.timeServers = [ "metadata.google.internal" ];

  networking.usePredictableInterfaceNames = false;

  # GC has 1460 MTU
  networking.interfaces.eth0.mtu = 1460;

  security.googleOsLogin.enable = true;

  systemd.services.google-clock-skew-daemon = {
    description = "Google Compute Engine Clock Skew Daemon";
    after = [
      "network.target"
      "google-instance-setup.service"
      "google-network-setup.service"
    ];
    requires = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${gce}/bin/google_clock_skew_daemon --debug";
    };
  };

  systemd.services.google-instance-setup = {
    description = "Google Compute Engine Instance Setup";
    after = ["local-fs.target" "network-online.target" "network.target" "rsyslog.service"];
    before = ["sshd.service"];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "sshd.service" "multi-user.target" ];
    path = with pkgs; [ ethtool openssh ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_instance_setup --debug";
      Type = "oneshot";
    };
  };

  systemd.services.google-network-daemon = {
    description = "Google Compute Engine Network Daemon";
    after = ["local-fs.target" "network-online.target" "network.target" "rsyslog.service" "google-instance-setup.service"];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    requires = ["network.target"];
    partOf = ["network.target"];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ iproute ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_network_daemon --debug";
    };
  };

  systemd.services.google-shutdown-scripts = {
    description = "Google Compute Engine Shutdown Scripts";
    after = [
      "local-fs.target"
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "systemd-resolved.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    wants = [ "local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${gce}/bin/google_metadata_script_runner --debug --script-type shutdown";
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStopSec = "infinity";
    };
  };

  systemd.services.google-startup-scripts = {
    description = "Google Compute Engine Startup Scripts";
    after = [
      "local-fs.target"
      "network-online.target"
      "network.target"
      "rsyslog.service"
      "google-instance-setup.service"
      "google-network-daemon.service"
    ];
    wants = ["local-fs.target" "network-online.target" "network.target"];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${gce}/bin/google_metadata_script_runner --debug --script-type startup";
      KillMode = "process";
      Type = "oneshot";
    };
  };

  environment.etc."sysctl.d/11-gce-network-security.conf".source = "${gce}/sysctl.d/11-gce-network-security.conf";
}
