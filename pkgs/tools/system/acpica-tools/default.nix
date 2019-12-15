{ stdenv, lib, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20191213";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1ip684is3dplf7snkn024vv6bg3dv5msx8v7pz6x9lrnk3gk0j9h";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bison flex ];

  NIX_CFLAGS_COMPILE = [ "-O3" "-Wno-error" ];

  PROGS = [
    "acpibin"
    "acpidump"
    "acpiexec"
    "acpihelp"
    "acpinames"
    "acpisrc"
    "acpixtract"

    # debug/test
    # "acpiexamples"
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
