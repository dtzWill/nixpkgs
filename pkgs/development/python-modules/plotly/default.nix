{ lib
, buildPythonPackage
, fetchPypi
, decorator
, nbformat
, pytz
, requests
, retrying
, six
# Test inputs
, numpy
, matplotlib
, coverage
, mock
, nose
, pytest
, backports_tempfile
, xarray
, scipy
# and quite a few others for various features I don't know are needed "yet".
# https://github.com/plotly/plotly.py/blob/master/packages/python/plotly/optional-requirements.txt
# Adding a few I'm interested in
, pandas
, psutil
, inflect
, colorcet
, ipython
, ipywidgets
# (TODO: jupyter bits, skipping for now)
, pyshp
, geopandas
, shapely
, pillow
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0iw0j2jwlbzknpbdpaqrjjlbycbwqhavp1crblvihf03knn7nkxz";
  };

  propagatedBuildInputs = [
    decorator
    nbformat
    pytz
    requests
    retrying
    six

    # Extras/optional
    pandas
    psutil
    inflect
    colorcet
    ipython
    ipywidgets
    # (TODO: jupyter bits, skipping for now)
    pyshp
    geopandas
    shapely
    pillow
  ];

  checkInputs = [
    numpy
    matplotlib
    coverage
    mock
    nose
    pytest
    backports_tempfile
    xarray
    pytz
    scipy
  ];

  # No tests in archive
  #doCheck = false;

  meta = with lib; {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = https://plot.ly/python/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
