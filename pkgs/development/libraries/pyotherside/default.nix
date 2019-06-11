{ stdenv, fetchFromGitHub
, python3, qmake, qtbase, qtquickcontrols, qtsvg, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "0c2l1d3kh7b8b1i93ja0ymyydkn4g1fjnp1dwx828c2d8ghkk5gg";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    python3 qtbase qtquickcontrols qtsvg ncurses
  ];

  patches = [
    ./qml-path.patch
    ./skip-python-config-wrapper-as-it-only-hurts-for-now.patch
  ];
  installTargets = [ "sub-src-install_subtargets" ];

  meta = with stdenv.lib; {
    description = "Asynchronous Python 3 Bindings for Qt 5";
    homepage = https://thp.io/2011/pyotherside/;
    license = licenses.isc;
    maintainers = [ maintainers.mic92 ];
  };
}
