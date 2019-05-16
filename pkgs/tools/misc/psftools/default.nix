{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "psftools";
  version = "1.0.12";

  src = fetchurl {
    url = "http://www.seasip.info/Unix/PSF/${pname}-${version}.tar.gz";
    sha256 = "17inkz328adcnv499mi3qxljf2ljnvag5s1msmm9bsd28sm52z1v";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Conversion tools for PSF fonts";
    homepage = https://www.seasip.info/Unix/PSF/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
