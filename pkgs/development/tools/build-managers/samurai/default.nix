{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "0k0amxpi3v9v68a8vc69r4b86xs12vhzm0wxd7f11vap1pnqz2cz";
  };

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "ninja-compatible build tool written in C";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}
