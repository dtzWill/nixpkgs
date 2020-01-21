{ stdenv, fetchurl, cmake, recode, perl, rinutils }:

stdenv.mkDerivation rec {
  pname = "fortune-mod";
  version = "2.12.0";

  src = fetchurl {
    url = "https://www.shlomifish.org/open-source/projects/fortune-mod/arcs/fortune-mod-${version}.tar.xz";
    sha256 = "0vglkg985al4hp1cxvm10r6wmkxjvrncigd5y5874fgdqx4i4hmn";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ recode rinutils ];

  cmakeFlags = [
    "-DLOCALDIR=${placeholder "out"}/share/fortunes"
  ];

  patches = [ (builtins.toFile "not-a-game.patch" ''
    diff --git a/CMakeLists.txt b/CMakeLists.txt
    index 865e855..5a59370 100644
    --- a/CMakeLists.txt
    +++ b/CMakeLists.txt
    @@ -154,7 +154,7 @@ ENDMACRO()
     my_exe(
         "fortune"
         "fortune/fortune.c"
    -    "games"
    +    "bin"
     )

     my_exe(
    -- 
  '') ];

  meta = with stdenv.lib; {
    description = "A program that displays a pseudorandom message from a database of quotations";
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
  };
}
