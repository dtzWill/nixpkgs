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
      url = "https://github.com/michaelforney/${pname}/compare/${src.rev}..9c1f015c21211c5df5822f70d3d5be81bd54fee2.patch";
      sha256 = "1iczhijrrhdhn7qyadm6v1q3pcz4nd862h5zns9yxr5mvrl5djbb";
    })
  ];

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "ninja-compatible build tool written in C";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}
