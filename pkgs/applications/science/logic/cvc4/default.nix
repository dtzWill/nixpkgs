{ stdenv, fetchurl, cln, gmp, swig, pkgconfig
, readline, libantlr3c, boost, jdk, autoreconfHook
, python3, antlr3_4
}:

stdenv.mkDerivation rec {
  name = "cvc4-${version}";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/CVC4/CVC4/archive/${version}.tar.gz";
    sha256 = "0blcixwgfkcdb4w66qj985h6hrdykk3dnv54cgzzfvh7l1ja6r4q";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gmp cln readline swig libantlr3c antlr3_4 boost jdk python3 ];
  configureFlags = [
    "--enable-language-bindings=c,c++,java"
    "--enable-gpl"
    "--with-cln"
    "--with-readline"
    "--with-boost=${boost.dev}"
  ];

  prePatch = ''
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/minisat
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/bvminisat
  '';

  preConfigure = ''
    patchShebangs ./src/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = http://cvc4.cs.stanford.edu/web/;
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice gebner ];
  };
}
