# fwupd daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwupd;
  originalEtc =
    let
      mkEtcFile = n: nameValuePair n { source = "${cfg.package}/etc/${n}"; };
    in listToAttrs (map mkEtcFile cfg.package.filesInstalledToEtc);
  extraTrustedKeys =
    let
      mkName = p: "pki/fwupd/${baseNameOf (toString p)}";
      mkEtcFile = p: nameValuePair (mkName p) { source = p; };
    in listToAttrs (map mkEtcFile cfg.extraTrustedKeys);

  # We cannot include the file in $out and rely on filesInstalledToEtc
  # to install it because it would create a cyclic dependency between
  # the outputs. We also need to enable the remote,
  # which should not be done by default.
  testRemote = if cfg.enableTestRemote then {
    "fwupd/remotes.d/fwupd-tests.conf" = {
      source = pkgs.runCommand "fwupd-tests-enabled.conf" {} ''
        sed "s,^Enabled=false,Enabled=true," \
        "${cfg.package.installedTests}/etc/fwupd/remotes.d/fwupd-tests.conf" > "$out"
      '';
    };
  } else {};
in {

  ###### interface
  options = {
    services.fwupd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable fwupd, a DBus service that allows
          applications to update firmware.
        '';
      };

      blacklistDevices = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [ "2082b5e0-7a64-478a-b1b2-e3404fab6dad" ];
        description = ''
          Allow blacklisting specific devices by their GUID
        '';
      };

      blacklistPlugins = mkOption {
        type = types.listOf types.string;
        default = [ "test" ];
        example = [ "udev" ];
        description = ''
          Allow blacklisting specific plugins
        '';
      };

      extraTrustedKeys = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ /etc/nixos/fwupd/myfirmware.pem ]";
        description = ''
          Installing a public key allows firmware signed with a matching private key to be recognized as trusted, which may require less authentication to install than for untrusted files. By default trusted firmware can be upgraded (but not downgraded) without the user or administrator password. Only very few keys are installed by default.
        '';
      };

      enableTestRemote = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable test remote. This is used by
          <link xlink:href="https://github.com/hughsie/fwupd/blob/master/data/installed-tests/README.md">installed tests</link>.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.fwupd;
        description = ''
          Which fwupd package to use.
        '';
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc = {
      "fwupd/daemon.conf" = {
        source = pkgs.writeText "daemon.conf" ''
          [fwupd]
          BlacklistDevices=${lib.concatStringsSep ";" cfg.blacklistDevices}
          BlacklistPlugins=${lib.concatStringsSep ";" cfg.blacklistPlugins}

          # Maximum archive size that can be loaded in Mb, with 0 for the default
          ArchiveSizeMax=0

          # Idle time in seconds to shut down the daemon -- note some plugins might
          # inhibit the auto-shutdown, for instance thunderbolt.
          #
          # A value of 0 specifies 'never'
          IdleTimeout=7200

          # Comma separated list of domains to log in verbose mode
          # If unset, no domains
          # If set to FuValue, FuValue domain (same as --domain-verbose=FuValue)
          # If set to *, all domains (same as --verbose)
          VerboseDomains=
        '';
      };
      "fwupd/uefi.conf" = {
        source = pkgs.writeText "uefi.conf" ''
          [uefi]
          OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
        ''; # TODO: RequireShimForSecureBoot=true ?
      };

      # Check kernel version for safety before attempting thunderbolt update
      # Since NixOS uses nearly-vanilla kernels, use suggested value.
      # Note that if not specified it appears this check is disabled.
      # XXX: Ensure this matches what fwupd says is needed, if it changes!
      "fwupd/thunderbolt.conf".source = pkgs.writeText "thunderbolt.conf" ''
        [thunderbolt]

        # Minimum kernel version to allow use of this plugin
        # It's important that all backports from this kernel have been
        # made if using an older kernel
        MinimumKernelVersion=4.13.0
      '';

    } // originalEtc // extraTrustedKeys // testRemote;

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d /var/lib/fwupd 0755 root root -"
    ];
  };

  meta = {
    maintainers = pkgs.fwupd.meta.maintainers;
  };
}
