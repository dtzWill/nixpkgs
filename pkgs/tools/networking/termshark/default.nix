{ stdenv, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "04wa83jwzbfbvkaxyip5qi0sg39m79lw0xqsc9f2a3kwm73jf5y6";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  modSha256 = "1lbs04ybgq3anicpyqk9px4da5cwzcqj352a2716mp8km2njnyrb";

  postFixup = ''
    wrapProgram $out/bin/termshark --prefix PATH : ${stdenv.lib.makeBinPath [ wireshark-cli ]}
  '';

  buildFlagsArray = ''
    -ldflags=
    -X github.com/gcla/termshark.Version=${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://termshark.io/;
    description = "A terminal UI for wireshark-cli, inspired by Wireshark";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.winpat ];
  };
}
