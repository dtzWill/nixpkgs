{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.20";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1dzcshg2j98szd0ak53r2y6bjxj92hyc9j6r80wcrw74jbm06fl3";
  };

  goPackagePath = "miniflux.app";

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X miniflux.app/version.Version=${version}
  '';

  postInstall = ''
    mv $bin/bin/miniflux.app $bin/bin/miniflux
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}

