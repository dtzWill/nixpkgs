{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l7id483006mnii4rlcff4p0ricd8a2n24sf74a9b387x0akpbsn";
  };

  modSha256 = "0ghp61m8fxg1iwq2ypmp99cqv3n16c06v2xzg9v34299vmd89gi2";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
