{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nz06q1rdrqgprclgr30la2vp4bx0qgibh22vdlqpd4rzi3x0h2r";
  };

  cargoSha256 = "1r87pyimbvqr0yjwpz6q7vqly9c0fk54aiafjsdzr6h4qbi0pq8w";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
