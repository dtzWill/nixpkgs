{ stdenv,  autoreconfHook, fetchFromGitHub, pkgconfig, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in
stdenv.mkDerivation rec {
  pname = "libplist";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "02vraf4j46bp746s0gz7vga2gv2dy3zd1v1bsy9x8algg9fpcb7n";
  };

  outputs = ["bin" "dev" "out" "py"];

  nativeBuildInputs = [
    pkgconfig
    python
    cython
    autoreconfHook
  ];

  propagatedBuildInputs = [ glib ];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with stdenv.lib; {
    description = "A library to handle Apple Property List format in binary or XML";
    homepage = https://github.com/libimobiledevice/libplist;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };
}
