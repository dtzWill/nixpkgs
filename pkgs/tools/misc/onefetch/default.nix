{
    cargo
  , makeRustPlatform
  , fetchFromGitHub
  , lib
  , ...
}:

let
  rustPlatform = makeRustPlatform {
    rustc = cargo;
    cargo = cargo;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "onefetch";
    version = "2.1.0";
    
    src = fetchFromGitHub {
      owner = "o2sh";
      repo = pname;
      rev = "v${version}";
      sha256 = "02mdzpzfcxp9na86b4jcqqjd3id5jslgmnq1jc0vykg58xha51jg";
    };
    cargoSha256 = "1phv06zf47bv5cmhypivljfiynrblha0kj13c5al9l0hd1xx749h";
    buildInputs = [ ];
    CARGO_HOME = "$(mktemp -d cargo-home.XXX)";

    meta = with lib; {
      homepage = https://github.com/o2sh/onefetch;
      description = ''Displays information about your Git project directly on your terminal'';
      license = licenses.mit;
      maintainers = with maintainers; [ kloenk ];
    };
  }
