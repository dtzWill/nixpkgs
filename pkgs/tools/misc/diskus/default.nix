{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "087w58q5kd3r23a9qnhqgvq4vhv69b5a6a7n3kh09g5cjszy8s05";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0x2mvlsm2pyhw6v3138g1ag1jq1rk02ks34d3fbbh0dhkdr7z7yh";

  meta = with stdenv.lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = https://github.com/sharkdp/diskus;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
  };
}
