{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1knqgq8xrlvwfc3y2hki6p0zr4dblm7max37y01p3bf641gs748z";
  };

  cargoSha256 = "0qxp3pjmrr53n59c2wcdnbqgk259zcj9gd11wpqf7kj3wlzrnwvy";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
