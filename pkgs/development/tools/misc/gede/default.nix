{ mkDerivation, lib, fetchurl, makeWrapper, python, qmake, universal-ctags, gdb }:

mkDerivation rec {
  pname = "gede";
  version = "2.15.1";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${pname}-${version}.tar.xz";
    sha256 = "0n67fiks7lbylgda8n06wfwcvl5qnb70rabk2b39g05byz7jcdcn";
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
