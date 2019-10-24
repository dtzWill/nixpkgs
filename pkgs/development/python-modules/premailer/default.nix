{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.6.1";

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "08pshx7a110k4ll20x0xhpvyn3kkipkrbgxjjn7ncdxs54ihdhgw";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cssselect cssutils lxml requests ];
}
