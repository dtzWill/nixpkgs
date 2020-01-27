{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "1jsxfpwa6q893x18qlvpsiym29rrw5cj0k805wgmk2n57j9rw4f2";
  };

  # Add support for compdb tool (compilation database)!
  patches = [
    (fetchpatch {
      url = "https://github.com/michaelforney/${pname}/compare/${src.rev}..fe1b3ce210fc333ad0b38a61dc413f8d105013d4.patch";
      sha256 = "1pbr7p829h8d9nx99s21qpb0qgj0y0hdz4wnx7h93mjfaagb8qlq";
    })
  ];

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "ninja-compatible build tool written in C";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}
