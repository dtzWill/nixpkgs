{ stdenv, fetchFromGitHub, makeWrapper, buildGoModule, wireshark-cli }:

buildGoModule rec {
  pname = "termshark";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "gcla";
    repo = "termshark";
    rev = "v${version}";
    sha256 = "186a38k4236id4z00l02hmzfhcra24pmziax5b9fgbjf8ima2pmz";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wireshark-cli ];

  modSha256 = "0r37c8s2dcv6v0zl0p0s893dk1faklppmrmx4vbpnb30i8vk8pwb";

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
