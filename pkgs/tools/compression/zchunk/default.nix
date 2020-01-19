{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, curl, openssl, zstd, argp-standalone }:

stdenv.mkDerivation rec {
  pname = "zchunk";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "13sqjslk634mkklnmzdlzk9l9rc6g6migig5rln3irdnjrxvjf69";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs =  [ curl openssl zstd ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl argp-standalone;
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.hostPlatform.isMusl "-largp";

  meta = with stdenv.lib; {
    description = "Easy-to-delta, compressed file format";
    license = licenses.bsd2;
    homepage = "https://github.com/zchunk/zchunk";
    maintainers = with maintainers; [ dtzWill ];
  };
}
