{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20190703";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "031m124a109vv6fx667h4ca2iav0xszrlvif9zcfxcaxbjsn6991";
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
