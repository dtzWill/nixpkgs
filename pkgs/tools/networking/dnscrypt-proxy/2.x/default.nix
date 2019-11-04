{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dnscrypt-proxy2";
  version = "2.0.31";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "1izhjdb7vns30gplfp3pi1rkdv04s5nbf6yrjr3nv95pf6m1skka";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
