{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "editline";
  version = "1.17.1";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "0y7vis52kfq2km9isrlzakpf7bn1k7v9vf3xg3q1cslla18q6myh";
  };

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/editline.html;
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
