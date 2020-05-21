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

  electron_7 = mkElectron "7.2.1" {
    x86_64-linux = "7e2b29221a6e857b1ab39a31c6e7790f6397fdadc5741295c1712485c5136f96";
    x86_64-darwin = "15e36ad6868728e0ed802222a511b7439c5da9808892dc41897b71603d479ba2";
    i686-linux = "a11f2249a35a6a016e58adbb8645ef029fdb36f8ce9e744512441303d088bc5c";
    armv7l-linux = "e153b9852ce73678834addff69b279016b2f12fde943a1904abb21965113f3ff";
    aarch64-linux = "30cf6309cf1a2f0b51d2da94d7089dd78d67e6f388f7a0e0e989afe58298f49e";
  };

  electron_8 = mkElectron "8.2.1" {
    x86_64-linux = "bb4b9fee98983a26f0f7ce3e19dd72ea5c7a5ad1f8cb17a7954ab4f6ab34a5a2";
    x86_64-darwin = "3dd2e09883b1ae2fac361c59fc671473889c6dbaecc0998cc35914ea76ddf0e4";
    i686-linux = "c04816aef0c331c8381dce50ed878b20fdbc928ce5254adcd3eaffbe980369e1";
    armv7l-linux = "098c349e977f8a1e69c15672a2b620d91c82c0ab9428f538cfb2c3c23c581b6f";
    aarch64-linux = "f2149c4ba29df79db21f96a3b06b1fb5933594e3883658b810a3100f38f138ee";
  };

}
