{ stdenv, lib, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20190816";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0p7ws106hf8bir9yb1a5m6v3wmvqagxmk3l9rpp4i89vib44vv3s";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bison flex ];

  PROGS = [
    "acpibin"
    "acpidump"
    "acpiexec"
    "acpihelp"
    "acpinames"
    "acpisrc"
    "acpixtract"
  ];
  makeFlags =  PROGS ++ [
    "PREFIX=${placeholder "out"}"
    "DESTDIR="
  ];

  meta = with lib; {
    description = "ACPICA Tools";
    homepage = "https://www.acpica.org/";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tadfisher ];
  };
}
