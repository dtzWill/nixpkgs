{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "sbase";
  version = "unstable-2019-11-02";

  src = fetchgit {
    url = "git://git.suckless.org/${pname}";
    rev = "27f3ca6063c0d28af045d2e4a9ffac352fd322f9";
    sha256 = "0y4qds5m499jma4yp5j1k1q0i8iycfmjd3cpd9qrq2bymjd8gs10";
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
