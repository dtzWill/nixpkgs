{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20190108";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0bqhr3ndchvfhxb31147z8gd81dysyz5dwkvmp56832d0js2564q";
  };

  nativeBuildInputs = [ bison flex ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

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
