{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "shadowfox";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "01cnfwdhcyjy6g7c2vmmrrnpj0rmpv2l8bfqvivfkylxvj7iz2wg";
  };

  goPackagePath = "github.com/SrKomodo/shadowfox-updater";

  modSha256 = "0anxrff09r5aw3a11iph0gigmcbmpfczm8him6ly57ywfzc5c850";

  buildFlags = "--tags release";

  meta = with stdenv.lib; {
    description = ''
      This project aims at creating a universal dark theme for Firefox while
      adhering to the modern design principles set by Mozilla.
    '';
    homepage = "https://overdodactyl.github.io/ShadowFox/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
