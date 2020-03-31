{ branch ? "stable", pkgs }:

let
  inherit (pkgs) callPackage fetchurl;
in {
  stable = callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.10";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0kx92i8naqr3algmyy3wyzbh8146z7gigxwf1nbpg1gl16wlplaq";
    };
  };
  ptb = callPackage ./base.nix rec {
    pname = "discord-ptb";
    binaryName = "DiscordPTB";
    desktopName = "Discord PTB";
    version = "0.0.18";
    src = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
      sha256 = "1v9xph7shpmabwysbc08qqlkydzgsir8rwarrjf01xmpcpyia17g";
    };
  };
  canary = callPackage ./base.nix rec {
    pname = "discord-canary";
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    version = "0.0.102";
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "1zl53vprkwbkfn3v0lddpp1swignqjxksi4qxl5zqj7482j372a4";
    };
  };
}.${branch}
