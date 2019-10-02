{ fetchFromGitHub, fetchpatch, lib, buildPythonPackage, fonttools, numpy, pillow, scour }:

buildPythonPackage rec {
  version = "unstable-2019-03-20";
  name = "nototools-${version}";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "9c4375f07c9adc00c700c5d252df6a25d7425870";
    sha256 = "0z9i23vl6xar4kvbqbc8nznq3s690mqc5zfv280l1c02l5n41smc";
  };

  patches = [
    # XXX: This is WIP and may eat your fonts or even change hash as it evolves
    (fetchpatch {
      url = "https://github.com/googlefonts/nototools/pull/488.patch";
      sha256 = "0h5956vzsbdzg2glvxpx4f5njkrgpd4sa3h6x96x1mp8433krn0h";
    })
  ];

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

  meta = {
    description = "Noto fonts support tools and scripts plus web site generation";
    license = lib.licenses.asl20;
    homepage = https://github.com/googlefonts/nototools;
  };
}
