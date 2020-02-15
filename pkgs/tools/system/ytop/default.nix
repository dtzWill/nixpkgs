{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "09zpqw7nnwbc7h38fb8lsa77i77kav8ijszw8nyzzr7za7z928c9";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "1as4zk0fg4n7rmpw6p1frwnr4l83a61adq7r68aam1v2cl5sjwgd";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = https://github.com/cjbassi/ytop;
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
