{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.5.4";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "0b0vxhxvx7ni75q23lbfjw6jhfvvhpi0bif5m9jbavgivigzlwjs";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
