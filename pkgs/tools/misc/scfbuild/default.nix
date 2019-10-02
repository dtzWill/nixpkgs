{ lib, fetchFromGitHub, fetchpatch, buildPythonApplication, python, pyyaml, fonttools, fontforge }:

buildPythonApplication rec {
  name = "scfbuild-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "scfbuild";
    rev = "9acc7fc5fedbf48683d8932dd5bd7583bf922bae";
    sha256 = "1zlqsxkpg7zvmhdjgbqwwc9qgac2b8amzq8c5kwyh5cv95zcp6qn";
  };

  patches = [
    # WIP py3 PR!
    (fetchpatch {
      url = "https://github.com/13rac1/scfbuild/pull/19.patch";
      sha256 = "1d512i87glp8l24zk6ngp04ac1mxjvqr7hslnflhhyi022z9rgyc";
    })
  ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  propagatedBuildInputs = [ pyyaml fonttools fontforge ];

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    cp -r scfbuild $out/${python.sitePackages}
    cp -r bin $out
  '';

  meta = with lib; {
    description = "SVGinOT color font builder";
    homepage = https://github.com/eosrei/scfbuild;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
