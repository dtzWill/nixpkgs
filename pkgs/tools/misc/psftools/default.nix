{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "psftools";
  version = "1.0.13";

  src = fetchurl {
    url = "http://www.seasip.info/Unix/PSF/${pname}-${version}.tar.gz";
    sha256 = "0rgg1lhryqi6sgm4afhw0z6pjivdw4hyhpxanj8rabyabn4fcqcw";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Conversion tools for PSF fonts";
    homepage = https://www.seasip.info/Unix/PSF/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
