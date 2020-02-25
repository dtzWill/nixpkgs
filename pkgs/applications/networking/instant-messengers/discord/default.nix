{ branch ? "stable", pkgs }:

let
  inherit (pkgs) callPackage fetchurl;
in {
  stable = callPackage ./base.nix {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.10";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0kx92i8naqr3algmyy3wyzbh8146z7gigxwf1nbpg1gl16wlplaq";
    };
  };
  ptb = callPackage ./base.nix {
    pname = "discord-ptb";
    binaryName = "DiscordPTB";
    desktopName = "Discord PTB";
    version = "0.0.15";
    src = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/0.0.15/discord-ptb-0.0.15.tar.gz";
      sha256 = "0znqb0a3yglgx7a9ypkb81jcm8kqgc6559zi7vfqn02zh15gqv6a";
    };
  };
  canary = callPackage ./base.nix {
    pname = "discord-canary";
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    version = "0.0.93";
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/0.0.93/discord-canary-0.0.93.tar.gz";
      sha256 = "1jzm5fm7a1p68ims7bv5am0bpbvrhbynzblpj9qrzzrwakdaywbi";
    };
  };
}.${branch}
