{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "0k0amxpi3v9v68a8vc69r4b86xs12vhzm0wxd7f11vap1pnqz2cz";
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
