{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "boost-build";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "build";
    rev = version;
    sha256 = "180083z9ga4p8jicn83m7ghcg1prypfgwx1hwy2gdhw8807k13rw";
  };

  hardeningDisable = [ "format" ];

  patchPhase = ''
    grep -r '/usr/share/boost-build' \
      | awk '{split($0,a,":"); print a[1];}' \
      | xargs sed -i "s,/usr/share/boost-build,$out/share/boost-build,"
  '';

  buildPhase = ''
    ./bootstrap.sh
  '';

  installPhase = ''
    ./b2 install --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.boost.org/boost-build2/;
    license = stdenv.lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
