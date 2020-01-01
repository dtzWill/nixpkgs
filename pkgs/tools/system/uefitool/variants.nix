{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A56";
    sha256 = "0sxmjkrwcchxg2qmcjsw2vr42s7cdcg2fxkwb8axq2r2z23465gp";
  };
  unstable = common rec {
    version = "t20190818";
    sha256 = "007qf50gmam23kzmkr7vnv9n0mwd7p32ai67qmd4ga6qmjbq1acm";
  };
  old-engine = common rec {
    version = "0.27.0";
    sha256 = "1i1p823qld927p4f1wcphqcnivb9mq7fi5xmzibxc3g9zzgnyc2h";
  };
}
