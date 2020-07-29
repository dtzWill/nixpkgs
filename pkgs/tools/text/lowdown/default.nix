{ stdenv, fetchFromGitHub, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.7.1";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  # for ./configure, probably could patch around instead
  nativeBuildInputs = [ which ];

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "0vmvcqd9dazsfg87m5ga7w00ajd5wnhl72059a6yla55j37swr1z";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
