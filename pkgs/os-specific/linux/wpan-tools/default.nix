{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libnl }:

stdenv.mkDerivation rec {
  pname = "wpan-tools";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "linux-wpan";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1m7lcxg1nha12170vw6m29dlbmw6ryxxlv597x72vpmj3am5519c";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libnl ];

  # TODO: meta
}
