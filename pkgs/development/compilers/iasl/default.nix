{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20191213";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1ip684is3dplf7snkn024vv6bg3dv5msx8v7pz6x9lrnk3gk0j9h";
  };

  nativeBuildInputs = [ bison flex ];

  NIX_CFLAGS_COMPILE = [ "-O3" "-Wno-error" ];

  PROGS = [ "iasl" ];
  makeFlags = PROGS ++ [
    "PREFIX=${placeholder "out"}"
    "DESTDIR="
  ];

  meta = {
    description = "Intel ACPI Compiler";
    homepage = http://www.acpica.org/;
    license = stdenv.lib.licenses.iasl;
    platforms = stdenv.lib.platforms.unix;
  };
}
