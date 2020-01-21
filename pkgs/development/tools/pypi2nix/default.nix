{ python3
}:
with python3;

pkgs.buildPythonApplication rec {
  pname = "pypi2nix";
  version = "2.0.4";
  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0y4zkkcijz5hchd8j6a106ysrg1dnad7dzdgnmz38rgm6zbrky0d";
  };
  checkInputs = with pkgs; [ pytest ];
  buildInputs = with pkgs; [ setuptools_scm ];
  propagatedBuildInputs = with pkgs; [
    attrs
    click
    jinja2
    nix-prefetch-github
    packaging
    parsley
    setuptools
    toml
  ];
  checkPhase = "${python3.interpreter} -m pytest unittests -m 'not nix'";
}
