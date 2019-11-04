{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, asciidoc, libxslt, docbook_xsl
, pam, yubikey-personalization, libyubikey, libykclient }:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "unstable-2019-10-25";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "04f26f7d293efd00f325fe72a63e8039b7b6cef0";
    sha256 = "0b2c7p9g4p2q4rc9f1gklzc1jzni3k8lh2v52qjj60izm7wadp62";
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
