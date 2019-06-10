{ lib, buildGoModule, fetchFromGitHub }:

with lib;

buildGoModule rec {
  pname = "go-md2man";
  version = "1.0.10";

  goPackagePath = "github.com/cpuguy83/go-md2man";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "1bqkf2bvy1dns9zd24k81mh2p1zxsx2nhq5cj8dz2vgkv1xkh60i";
  };

  modSha256 = "1cdgw84brpwpn2zhs6g0hb1i8fwx5l3fvjwy37ni1fshymqin0ag";

  meta = {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = https://github.com/cpuguy83/go-md2man;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
