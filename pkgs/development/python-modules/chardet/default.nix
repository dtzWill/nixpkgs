{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, pytestrunner, hypothesis }:

buildPythonPackage rec {
  pname = "chardet";
  version = "3.0.4";

  # pypi doesn't have test.py
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1qf47svg3x7l892d6vnwjhd6lnan3dw40avmbg33rxkf0qzl8jgf";
  };

  patches = [
    # Add pytest 4 support. See: https://github.com/chardet/chardet/pull/174
    (fetchpatch {
      url = "https://github.com/chardet/chardet/commit/0561ddcedcd12ea1f98b7ddedb93686ed8a5ffa4.patch";
      sha256 = "1y1xhjf32rdhq9sfz58pghwv794f3w2f2qcn8p6hp4pc8jsdrn2q";
    })
  ];

  checkInputs = [ pytest pytestrunner hypothesis ];

  meta = with stdenv.lib; {
    homepage = https://github.com/chardet/chardet;
    description = "Universal encoding detector";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };
}
