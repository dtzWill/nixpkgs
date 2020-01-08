{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools
, dateutil
, pytz
}:

buildPythonPackage rec {
  version = "4.0.4";
  pname = "icalendar";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16gjvqv0n05jrb9g228pdjgzd3amz2pdhvcgsn1jypszjg5m2w9l";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/collective/icalendar/pull/283.patch";
      sha256 = "10ymazs6s4kfg3nkrw58k2765z33fi1z898s5a638a4f3ipcjspn";
    })
  ];

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ dateutil pytz ];

  meta = with stdenv.lib; {
    description = "A parser/generator of iCalendar files";
    homepage = "https://icalendar.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };

}
