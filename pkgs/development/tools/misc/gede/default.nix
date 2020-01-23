{ mkDerivation, lib, fetchurl, makeWrapper, python, qmake, universal-ctags, gdb }:

mkDerivation rec {
  pname = "gede";
  version = "2.15.4";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${pname}-${version}.tar.xz";
    sha256 = "0bg7vyvznn1gn6w5yn14j59xph9psf2fyxr434pk62wmbzdpmkfg";
  };

  nativeBuildInputs = [ qmake makeWrapper python ];

  buildInputs = [ universal-ctags ];

  dontUseQmakeConfigure = true;

  buildPhase = ":";

  installPhase = ''
    python build.py --verbose --prefix="$out"
    python build.py --verbose --prefix="$out" install
    wrapProgram $out/bin/gede \
      --prefix PATH : ${lib.makeBinPath [ universal-ctags gdb ]} 
  '';

  meta = with lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = http://gede.acidron.com;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}
