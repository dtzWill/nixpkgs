{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  name = "hyperfine-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hyperfine";
    rev    = "refs/tags/v${version}";
    sha256 = "16xxznz8xkflw7dvlzayx4g0ia0cqdv28yxbr0r2dx7v8w9vx2cn";
  };

  cargoSha256 = "1smsv8rcj1gdm07if7bd43znrm99qb8i1y3wr22pjdnr5nkjfdpx";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
