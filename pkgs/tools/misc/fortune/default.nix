{ stdenv, fetchurl, cmake, recode, perl }:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "2.10.0";

  src = fetchurl {
    url = "https://www.shlomifish.org/open-source/projects/fortune-mod/arcs/fortune-mod-${version}.tar.xz";
    sha256 = "07g50hij87jb7m40pkvgd47qfvv4s805lwiz79jbqcxzd7zdyax7";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ recode ];

  postInstall = ''
    mv -v $out/games/fortune $out/bin/fortune
    rmdir -v $out/games
  '';

  meta = with stdenv.lib; {
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
  };
}
