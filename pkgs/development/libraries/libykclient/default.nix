{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, curl }:

stdenv.mkDerivation rec {
  pname = "libykclient";
  version = "unstable-2020-01-10";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-c-client";
    rev = "508a8b8df8b4d60bc54744817f44e8504703a29c";
    sha256 = "0plvvpck0li0cbn0wwjiikx4ixvwqmlzw88mr0373jkgzlzkqybb";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig help2man ];
  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "Yubikey C client library";
    homepage = https://developers.yubico.com/yubico-c-client;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
