{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0gby17jr2xcjwk295xi3qvrfd6yg6mlv30fbscp0xs029rp69607";
  };

  cargoSha256 = "005sfq1hvw3p1q7d4dkfb5z3r1vzvgqmbl4nmmrhpdizrcqjk7mi";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
