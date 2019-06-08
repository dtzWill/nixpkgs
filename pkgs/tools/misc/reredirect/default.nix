{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "reredirect";
  version = "v0.2";

  src = fetchFromGitHub {
    owner = "jerome-pouiller";
    repo = "reredirect";
    rev = version;
    sha256 = "0aqzs940kwvw80lhkszx8spcdh9ilsx5ncl9vnp611hwlryfw7kk";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool to dynamicly reredirect outputs of a running process";
    homepage = "https://github.com/jerome-pouiller/reredirect";
    license = licenses.mit;
    maintainers = [ maintainers.tobim ];
    platforms = ["i686-linux" "x86_64-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux"];
  };
}

