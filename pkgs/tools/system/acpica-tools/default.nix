{ stdenv, lib, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20200110";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1cb6aa6acrixmdzvj9vv4qs9lmlsbkd27pjlz14i1kq1x3xn0gwx";
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
