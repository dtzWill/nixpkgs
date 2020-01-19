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
  version = "unstable-2020-01-17";

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
    rev = "93216e6a29298bc25bd05558e0fade2226038a7e";
    sha256 = "0clj5w4a1haazp6jwd4lvfq4nszfk6mq3vhfnsmqzgnyjfmpj82w";
  };

  cargoSha256 = "0k7l0zhk2vzf4nlwv4xr207irqib2dqjxfdjk1fprff84c4kblx8";
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
