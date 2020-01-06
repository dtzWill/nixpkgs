{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "sbase";
  version = "unstable-2020-01-06";

  src = fetchgit {
    url = "git://git.suckless.org/${pname}";
    rev = "f3d05ffd0ac4226f9064be5c71606ab9b7d12d92";
    sha256 = "0mhmmrlzx6vba5m5vfk906ybyafwdqbqq560j9vnjraw0xax72wr";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "suckless unix tools";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
