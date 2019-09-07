{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomuks";
  version = "2019-07-26";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "7012564d0ee8481c0e4c5ecb359f77d12c9f793b";
    sha256 = "08yiyb5fd3407wb7jc51y75hs3mhjzqca8mq0jz0vdamkhiz4f21";
  };

  modSha256 = "1jqah0998x1alwd4g4cil5n5zji2qff2c3nhkiibsr5d65p46k4a";

  meta = with stdenv.lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner ];
    platforms = platforms.unix;
  };
}
