{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.6.2";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "1jiksl9alzdxwwygcwl5h5qp24h3j3cakrmqimm9ldklg6dm0zpa";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
