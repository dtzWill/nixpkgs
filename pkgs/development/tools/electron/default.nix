{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core, libappindicator-gtk3 }@args:
let
  mkElectron = import ./generic.nix args;
in
{
  electron_4 = mkElectron "4.2.12" {
    x86_64-linux = "72c5319c92baa7101bea3254a036c0cd3bcf257f4a03a0bb153668b7292ee2dd";
    x86_64-darwin = "89b0e16bb9b7072ed7ed1906fccd08540acdd9f42dd8a29c97fa17d811b8c5e5";
    i686-linux = "bf96b1736141737bb064e48bdb543302fd259de634b1790b7cf930525f47859f";
    armv7l-linux = "2d970b3020627e5381fd4916dd8fa50ca9556202c118ab4cba09c293960689e9";
    aarch64-linux = "938b7cc5f917247a120920df30374f86414b0c06f9f3dc7ab02be1cadc944e55";
  };

  electron_5 = mkElectron "5.0.13" {
    x86_64-linux = "8ded43241c4b7a6f04f2ff21c75ae10e4e6db1794e8b1b4f7656c0ed21667f8f";
    x86_64-darwin = "589834815fb9667b3c1c1aa6ccbd87d50e5660ecb430f6b475168b772b9857cd";
    i686-linux = "ccf4a5ed226928a30bd3ea830913d99853abb089bd4a6299ffa9fa0daa8d026a";
    armv7l-linux = "96ad83802bc61d87bb952027d49e5dd297f58e4493e66e393b26e51e09065add";
    aarch64-linux = "01f0fd313b060fb28a1022d68fb224d415fa22986e2a8f4aded6424b65e35add";
  };

  electron_6 = mkElectron "6.1.9" {
    x86_64-linux = "ae739863c4b18b47de559cbd64f4671e41f5949d6be8a98a807f57fa241560a0";
    x86_64-darwin = "c667072f9c3d3636b58b829453176f1090cf29529a68e8b1463ce6fb295f2894";
    i686-linux = "c29ab419e6acd534c4da6fe1eddad32e286044b74e1c3f123d7a166580e18ed3";
    armv7l-linux = "4064a223faf6ead8e2343ad40cb8e5864b8689eedd0e74f452b27b6422f75a38";
    aarch64-linux = "9b0aadb607be7e0ccc687ac5cd58334439566d1ce76c855597cfb098044a3ec7";
  };

  electron_7 = mkElectron "7.1.14" {
    x86_64-linux = "eff2b4ab67cf9bed50e02826afe00653263efa770176a9a08c581854248ecfc1";
    x86_64-darwin = "28b416fd88b9fb68478cf04bfd06f409a9e29ef5dde2d2b48547ccc7ddb7ea6f";
    i686-linux = "6095fd76347b0e9b1af1c46dfc27e7641d1dcc6f7760132547af8098673cdb14";
    armv7l-linux = "e30f09a025043c328ceff02f041defce27f35bc4183bc358c668214c872611ae";
    aarch64-linux = "dc5b31a00f1ff72eb32c533dd2510f9378c60b460261570487a3b86b4d0c4d4d";
  };

  electron_8 = mkElectron "8.0.3" {
    x86_64-linux = "2bdce394020fa4b9eb61ccc0396d69d2f61ec20eada168493cbe245a642df7d9";
    x86_64-darwin = "e4e64b591de496d16107b524774c85f7bb81efc5c034e1e1abdf3a5fe63f62eb";
    i686-linux = "31776ba95ea20cb2b611939574ebe0155788cbea9a937326ba8f1b5aadb88794";
    armv7l-linux = "a470189e390feb2e0e9cee9d45bf63a85d9df77a3e830d8623c548f45410b58b";
    aarch64-linux = "a08cc75a807b5a262148ce5969596a6d05c0f1854d52da44d14649620f11f8ca";
  };

}
