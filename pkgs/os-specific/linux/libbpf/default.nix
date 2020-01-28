{ stdenv, fetchFromGitHub, pkgconfig
, libelf
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0x82iyzq37rm7r961arivgfm099n0sxwrqibmkwnbwkq74xw20z1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libelf ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  patchPhase = ''
    substituteInPlace ../scripts/check-reallocarray.sh \
      --replace '/bin/rm' 'rm'
  '';

  # FIXME: Multi-output requires some fixes to the way the pkgconfig file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Upstream mirror of libbpf";
    homepage    = "https://github.com/libbpf/libbpf";
    license     = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
  };
}
