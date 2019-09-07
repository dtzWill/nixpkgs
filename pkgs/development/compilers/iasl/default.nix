{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20190816";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0p7ws106hf8bir9yb1a5m6v3wmvqagxmk3l9rpp4i89vib44vv3s";
  };

  nativeBuildInputs = [ bison flex ];

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
