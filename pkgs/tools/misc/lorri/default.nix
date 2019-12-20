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
  version = "unstable-2019-12-20";

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
    rev = "7ff97e14e8ecbd84a8c35ed8cb2885691a827d7a";
    sha256 = "1hv2pll7f0lm7ndygb01019ivhvzjr3nycs4p7x1ndbks6dz5j5n";
  };

  cargoSha256 = "1f4bbdg2b5g5rhq0c8r1dk5wqpi6x00hjzrwb8cnhgys4qqa2g95";
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ nix direnv which ];
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
