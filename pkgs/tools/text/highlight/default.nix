{ stdenv, fetchFromGitLab, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "highlight";
  version = "3.52";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zhn1k70ck82ks7ckzsy1yiz686ym2ps7c28wjmkgxfpyjanilrq";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ] ++ optional stdenv.isDarwin  gcc ;

  # TODO: gui! (qt, make optional)
  buildInputs = [ getopt lua boost ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=${placeholder "out"}"
    "conf_dir=${placeholder "out"}/etc/highlight"
  ];

  meta = with stdenv.lib; {
    description = "Source code highlighting tool";
    homepage = http://www.andre-simon.de/doku/highlight/en/highlight.php;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ndowens willibutz ];
  };
}
