{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.5.3";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "0m7wn5pkk1ak8nrzwvn41vvl3i0wfnx4gk0pvd50h4gwkrz3rc5r";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
