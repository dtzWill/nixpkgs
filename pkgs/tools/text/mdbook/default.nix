{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0z3srqgdnyf3kjjkxk5k1xm3ziif13dvacz5p60w79gqff4giq4n";
  };

  cargoSha256 = "0mwspxsxvdbxqqqrp2sq0myf8krcjz99ml5af3ak15gqcpwk6wqs";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = https://github.com/rust-lang-nursery/mdbook;
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
