{ lib, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  pname = "go-md2man";
  version = "1.0.10";

  goPackagePath = "github.com/cpuguy83/go-md2man";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "1bqkf2bvy1dns9zd24k81mh2p1zxsx2nhq5cj8dz2vgkv1xkh60i";
  };

  meta = {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = https://github.com/cpuguy83/go-md2man;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
