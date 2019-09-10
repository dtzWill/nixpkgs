{ libsForQt5 }:
let
  common = opts: libsForQt5.callPackage (import ./common.nix opts) {};
in rec {
  new-engine = common rec {
    version = "A55";
    sha256 = "126ay3qk38z67pr1lz3nz8qjs1sr1csc4fa45j37a2wk2fbwwra4";
  };
  unstable = common rec {
    #version = "t20190818";
    version = "f2e343d8bf3ed393cf65fa03224e798317eb9ad8"; # unstable-2019-09-06";
    sha256 = "0g005y0n5bncd9v8zm22yldx49gw31s3wdwmhr928k0bss3b9spp";
  };
  old-engine = common rec {
    version = "0.26.0";
    sha256 = "1ka7i12swm9r5bmyz5vjr82abd2f3lj8p35f4208byalfbx51yq7";
  };
}
