{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.5.0";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "0d29s7j1q3fs0yqsqm96ksrdkzd3q7anija4z5wpn9n15c9f4br2";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
