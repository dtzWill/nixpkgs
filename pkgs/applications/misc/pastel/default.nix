{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xrg25w175m2iz7q9v7c05a0p0v5rr71vd4m3v6p0lqvij3sih4s";
  };

  cargoSha256 = "0j18mib2jizphxwcqw8w9yprfgs89vsp58cj97sby1fwllnywfyb";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = https://github.com/sharkdp/pastel;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
