{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, asciidoc, libxslt, docbook_xsl
, pam, yubikey-personalization, libyubikey, libykclient }:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "unstable-2020-01-09";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "dac07a76f0ecbcc41aaad55c866a7d08e0a97e71";
    sha256 = "1m1mcff994n9fl7mflp8k71zzkfg1vgra380rx9rm9nzfxql29j8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc libxslt docbook_xsl ];
  buildInputs = [ pam yubikey-personalization libyubikey libykclient ];

  meta = with stdenv.lib; {
    description = "Yubico PAM module";
    homepage = https://developers.yubico.com/yubico-pam;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
