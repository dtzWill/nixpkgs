{ stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
  # Updater script
, runtimeShell
, writeScript
  # Tests
, nixosTests
  # Apple dependencies
, CoreServices
, Security
, cf-private
}:

rustPlatform.buildRustPackage rec {
  pname = "lorri";
  version = "unstable-2020-01-28";

  meta = with stdenv.lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/target/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
    rev = "2a26a4fb9c0121b4489b8b660dcaac0178e5dccb";
    sha256 = "0n13h5rpw6hn5d8icqs6xrvnls0c979zx96rj90kbnsxrkwjf0z2";
  };

  cargoSha256 = "1kdpzbn3353yk7i65hll480fcy16wdvppdr6xgfh06x88xhim4mp";
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ nix direnv which rustfmt ];
  buildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security cf-private ];

  passthru = {
    updater = with builtins; writeScript "copy-runtime-nix.sh" ''
      #!${runtimeShell}
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };
}
