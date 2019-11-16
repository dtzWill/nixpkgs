{ stdenv, lib, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  pname = "acpica-tools";
  version = "20191018";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0pz95fb1zvsj9238bg7a4vxl1svn5mnjg10sn5qvgr008q0v9782";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bison flex ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

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
