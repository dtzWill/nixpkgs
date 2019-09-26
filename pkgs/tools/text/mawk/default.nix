{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20190203";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/${pname}-${version}.tgz"
    ];
    sha256 = "0h5qlslaj5czz4v25hqg8a6kg4c5mlkmdpxhhvpvp1ci08ab7b6s";
  };

  meta = with stdenv.lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = https://invisible-island.net/mawk/mawk.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
