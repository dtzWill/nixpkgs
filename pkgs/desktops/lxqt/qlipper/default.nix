{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qttools }:

mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qlipper";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = version;
    sha256 = "0zpkcqfylcfwvadp1bidcrr64d8ls5c7bdnkfqwjjd32sd35ly60";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase qttools ];

  meta = with lib; {
    description = "Cross-platform clipboard history applet";
    homepage = https://github.com/pvanek/qlipper;
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
