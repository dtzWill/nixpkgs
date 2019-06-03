{ stdenv, fetchurl, makeWrapper, python, qmake, universal-ctags, gdb }:

stdenv.mkDerivation rec {
  name = "gede-${version}";
  version = "2.14.1";

  src = fetchurl {
    url = "http://gede.acidron.com/uploads/source/${name}.tar.xz";
    sha256 = "1z7577zwz7h03d58as93hyx99isi3p4i3rhxr8l01zgi65mz0mr9";
  };

  nativeBuildInputs = [ qmake makeWrapper python ];

  buildInputs = [ universal-ctags ];

  dontUseQmakeConfigure = true;

  buildPhase = ":";

  installPhase = ''
    python build.py --verbose --prefix="$out"
    python build.py --verbose --prefix="$out" install
    wrapProgram $out/bin/gede \
      --prefix PATH : ${stdenv.lib.makeBinPath [ universal-ctags gdb ]}
  '';

  meta = with stdenv.lib; {
    description = "Graphical frontend (GUI) to GDB";
    homepage = http://gede.acidron.com;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ juliendehos ];
  };
}
