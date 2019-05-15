{ fetchFromGitHub, lib, buildPythonPackage, isPy3k, fonttools, numpy, pillow, scour }:

buildPythonPackage rec {
  version = "2019-03-19";
  name = "nototools-${version}";

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "nototools";
    rev = "9c4375f07c9adc00c700c5d252df6a25d7425870";
    sha256 = "0z9i23vl6xar4kvbqbc8nznq3s690mqc5zfv280l1c02l5n41smc";
  };

  propagatedBuildInputs = [
    fonttools numpy
    # requirements.txt
    # booleanOperations==0.7.0
    # defcon==0.3.1
    # fonttools>=3.36.0
    # Pillow==4.0.0
    pillow
    # pyclipper==1.0.6
    # ufoLib==2.0.0
    # scour==0.37
    scour
  ];

  disabled = isPy3k;

  meta = {
    description = "Noto fonts support tools and scripts plus web site generation";
    license = lib.licenses.asl20;
    homepage = https://github.com/googlei18n/nototools;
  };
}
