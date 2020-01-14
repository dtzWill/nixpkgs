{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20200110";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1cb6aa6acrixmdzvj9vv4qs9lmlsbkd27pjlz14i1kq1x3xn0gwx";
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
