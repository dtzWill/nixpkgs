{ buildGoPackage, stdenv, fetchFromGitHub }:

buildGoPackage rec {
  version = "2.1.0";
  pname = "xurls";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cwl52vcmhxnnx33pqd3cprw6yjv988qhyf42d4sblw7l2gqgilc";
  };

  goPackagePath = "mvdan.cc/xurls/v2";
  subPackages = [ "cmd/xurls" ];

  meta = with stdenv.lib; {
    description = "Extract urls from text";
    homepage = https://github.com/mvdan/xurls;
    maintainers = with maintainers; [ koral ndowens ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
