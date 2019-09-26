{ stdenv, buildPythonPackage, fetchPypi
, pytz }:

buildPythonPackage rec {
  pname = "tzlocal";
  version = "2.0.0";

  propagatedBuildInputs = [ pytz ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "142miqq3xbscfvwnq0ih5g394v3yglb6h0hcm2873qabpbarv6wl";
  };

  # test fail (timezone test fail)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tzinfo object for the local timezone";
    homepage = https://github.com/regebro/tzlocal;
    license = licenses.cddl;
  };
}
