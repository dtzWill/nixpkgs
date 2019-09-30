{ stdenv, fetchurl, pkg-config, ncurses, libiconv }:

stdenv.mkDerivation rec {
  pname = "dte";
  version = "1.9.1";

  src = fetchurl {
    url = "https://craigbarnes.gitlab.io/dist/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0b8sz1ac0wqsha253a95yrj2h0ysik11dk3f2bhva253d4i77ll0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses libiconv ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Small and easy to use console text editor";
    homepage = https://craigbarnes.gitlab.io/dte/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
