{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, asciidoc, libxslt, docbook_xsl
, pam, yubikey-personalization, libyubikey, libykclient }:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "unstable-2019-09-24";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "3d71fce7baf694ff8a3ef54d657f5fcbda5b507b";
    sha256 = "06q1b9dvkpwi1g3770mjxyxk74jxcb9g50mrvbzwibg6hx1aja72";
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
