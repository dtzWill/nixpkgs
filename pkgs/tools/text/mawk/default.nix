{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20200106";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/${pname}-${version}.tgz"
    ];
    sha256 = "1dhmn0l1c122a4bb07a1lwzrzpjdhsbdbllb1a9gwvv2lw5j9qgi";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = https://invisible-island.net/mawk/mawk.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
