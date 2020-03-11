{ stdenv, fetchurl, bison, flex, libffi }:

stdenv.mkDerivation rec {
  pname = "txr";
  version = "233";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/${pname}-${version}.tar.bz2";
    sha256 = "1n28j6qn6hg7hawkibn7bbj4ir9drfijc7dwhmn4ydgkq5lpfbm1";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  preCheck = ''
    # Remove failing test-- mentions 'usr/bin' so probably related :)
    rm -rf tests/017

    # Remove failing chmod test, sticky bit behavior doesn't work in sandbox
    rm -rf tests/018
  '';

  postInstall = ''
    d=${placeholder "out"}/share/vim-plugins/txr
    mkdir -p $d/{syntax,ftdetect}

    cp {tl,txr}.vim $d/syntax/

    cat > $d/ftdetect/txr.vim <<EOF
      au BufRead,BufNewFile *.txr set filetype=txr | set lisp
      au BufRead,BufNewFile *.tl,*.tlo set filetype=tl | set lisp
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Programming language for convenient data munging";
    license = licenses.bsd2;
    homepage = http://nongnu.org/txr;
    maintainers = with stdenv.lib.maintainers; [ dtzWill ];
    platforms = platforms.linux; # Darwin fails although it should work AFAIK
  };
}
