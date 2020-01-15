{ stdenv, fetchFromGitLab, python, pkgconfig
, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_412 }:

stdenv.mkDerivation rec {
  name = "irker-${version}";
  version = "2019-06-17";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "irker";
    rev = "ba5e80384b20d5718edd4e521dda319fab59d90f";
    sha256 = "13xkbma3iijsxr67m11v3zzczbvlmi3bsvzbwcz3kcm03jvqpxnb";
  };

  nativeBuildInputs = [ pkgconfig xmlto docbook2x docbook_xsl docbook_xml_dtd_412 ];

  buildInputs = [
    (python.withPackages (p: [ p.pysocks ]))
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-o 0 -g 0' ""
  '';

  installFlags = [
    "prefix=${placeholder "out"}"
    "DESTDIR="
  ];

  meta = with stdenv.lib; {
    description = "IRC client that runs as a daemon accepting notification requests";
    homepage = https://gitlab.com/esr/irker;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.unix;
  };
}
