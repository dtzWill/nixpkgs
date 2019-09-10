{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A55";
    sha256 = "126ay3qk38z67pr1lz3nz8qjs1sr1csc4fa45j37a2wk2fbwwra4";
  };
  unstable = common rec {
    version = "t20190818";
    sha256 = "007qf50gmam23kzmkr7vnv9n0mwd7p32ai67qmd4ga6qmjbq1acm";
  };
  old-engine = common rec {
    version = "0.26.0";
    sha256 = "1ka7i12swm9r5bmyz5vjr82abd2f3lj8p35f4208byalfbx51yq7";
  };
}
