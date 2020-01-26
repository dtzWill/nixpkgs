{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.5.2";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "00cjwsd3qwcp7kxdszby791h7n3ibaj81fd7gzxdk723swsj45w0";
  };

  prefixKey = "PREFIX=";

  meta = with stdenv.lib; {
    description = "Simple markdown translator";
    homepage = "https://kristaps.bsd.lv/lowdown";
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
  };
}
