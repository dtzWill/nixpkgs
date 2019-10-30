{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "dnscrypt-proxy2";
  version = "2.0.29";

  goPackagePath = "github.com/jedisct1/dnscrypt-proxy";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dnscrypt-proxy";
    rev = version;
    sha256 = "196yc34xw6h9qpns4n1fw8bjh8lv4xcsbx89i391qw92h2a3qkmc";
  };

  meta = with stdenv.lib; {
    description = "A tool that provides secure DNS resolution";

    license = licenses.isc;
    homepage = https://dnscrypt.info/;
    maintainers = with maintainers; [ waynr ];
    platforms = with platforms; unix;
  };
}
