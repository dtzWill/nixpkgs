{ lib, python3Packages }:

# for now just replace, but might be better to override in a new python.pkgs

let
  sqlparse_0_2 = python3Packages.sqlparse.overrideAttrs(o: rec {
    name = "${o.pname}-${version}";
    version = "0.2.4";
    src = python3Packages.fetchPypi {
      inherit (o) pname;
      inherit version;
      sha256 = "1v3xh0bkfhb262dbndgzhivpnhdwavdzz8jjhx9vx0xbrx2880nf";
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "litecli";
  version = "1.2.0";

  # Python 2 won't have prompt_toolkit 2.x.x
  # See: https://github.com/NixOS/nixpkgs/blob/f49e2ad3657dede09dc998a4a98fd5033fb52243/pkgs/top-level/python-packages.nix#L3408
  disabled = python3Packages.isPy27;

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "197yizdycph1m07fjchygqr5jh7vv54a0a7gpsgv51s31vy50ad4";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers
    click
    configobj
    prompt_toolkit
    pygments
    sqlparse_0_2
  ];

  checkInputs = with python3Packages; [
    pytest
    mock
  ];

  preCheck = ''
    export XDG_CONFIG_HOME=$TMP
    # add missing file
    echo "litecli is awesome!" > tests/test.txt
  '';

  meta = with lib; {
    description = "Command-line interface for SQLite";
    longDescription = ''
      A command-line client for SQLite databases that has auto-completion and syntax highlighting.
    '';
    homepage = https://litecli.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
