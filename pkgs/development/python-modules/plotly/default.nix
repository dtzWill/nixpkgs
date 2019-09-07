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
# Optionals:
# https://github.com/plotly/plotly.py/blob/master/packages/python/plotly/optional-requirements.txt
, pandas
, psutil
, inflect
, colorcet
, ipython
, ipywidgets
, ipykernel
, jupyter
, notebook # ?
, pyshp
, geopandas
, shapely
, pillow
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "166rscpr9xbs3pwd61mivhlm1gv3chkgpk2cy0fpb86axa7z4cwk";
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
    ipykernel
    jupyter
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

  # Tests mostly scold for not using a different package
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = https://plot.ly/python/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
