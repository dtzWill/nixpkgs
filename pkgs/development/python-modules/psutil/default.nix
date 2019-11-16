{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0isil5jxwwd8awz54qk28rpgjg43i5l6yl70g40vxwa4r4m56lfh";
  };

  # No tests in archive
  doCheck = false;

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.IOKit ];

  meta = {
    description = "Process and system utilization information interface for python";
    homepage = https://github.com/giampaolo/psutil;
    license = stdenv.lib.licenses.bsd3;
  };
}
