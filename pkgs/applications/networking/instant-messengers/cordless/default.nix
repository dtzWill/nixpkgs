{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  name = "cordless-${version}";
  version = "2020-06-26";

  src = fetchurl {
    url = "https://github.com/Bios-Marcel/cordless/archive/${version}.tar.gz";
    sha256 = "15kzz4md9xrj3j4rr0iqgr1j53xkihy246gmd7wamylza64cbklw";
  };

  doCheck = true;

  modSha256 = "05b5vai6wqv7x9sdry8m5k0cnl1098gg7k3iccs48sv8szs9gbir";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A third party Discord client";
    longDescription = ''
      Cordless is a third party Discord client that runs on the
      commandline and aims to have a low memory footprint and
      bandwidth consumption.
    '';
    homepage = https://www.github.com/Bios-Marcel/cordless;
    license = licenses.bsd3;
    maintainers = [ "Marcel Schramm <marceloschr@googlemail.com>" ];
    platforms = platforms.linux;
  };
}