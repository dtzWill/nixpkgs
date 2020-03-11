{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "1wpxn8i5112pzs8b03shl627r2yz70lvzjhd6f5crwhsnir06h5x";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "1gsbk8lksdsfxzz53g327wpc6dsfzmnmxyk2d5f8kjls30fq85jn";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = https://github.com/cjbassi/ytop;
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
