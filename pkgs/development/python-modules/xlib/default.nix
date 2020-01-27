{ stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools_scm
, xorg
, python
, mock
, nose
, utillinux
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.26";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = version;
    sha256 = "0r036ggn02fz98014gs8jyyg9vyz2p8q4dyilkl3w4kdj6kc5alf";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  checkInputs = [ mock nose utillinux /* mcookie */ xorg.xauth xorg.xorgserver /* xvfb */ ];
  nativeBuildInputs = [ setuptools_scm ];
  buildInputs = [ xorg.libX11 ];
  propagatedBuildInputs = [ six ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Fully functional X client library for Python programs";
    homepage = http://python-xlib.sourceforge.net/;
    license = licenses.gpl2Plus;
  };

}
