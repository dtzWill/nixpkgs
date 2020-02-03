{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core }@args:

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

  electron_6 = mkElectron "6.1.7" {
    x86_64-linux = "7fe94fc1edebe2f5645056a4300fc642c04155e55da8dd4ee058a0c0ef835ae8";
    x86_64-darwin = "1c790a4cbda05f1c136d18fa6a09bdb09a1941f521207466756a3e95e343c485";
    i686-linux = "1afd8ea79acb2b4782fb459e084549ed4cd4ead779764829b1d862148359eae5";
    armv7l-linux = "14f2ea0459f0dda8c566b0fa4a2fe755f4220bbae313ea0c453861ac2f803196";
    aarch64-linux = "80e05c1a0b51c335483666e959c1631a089246986b7fc3a4f9ee1288a57a602a";
  };

  electron_7 = mkElectron "7.1.11" {
    x86_64-linux = "a8986cd4d8fb579a0404840f85e29e55e5189815790e8af93d72e18689c81d4a";
    x86_64-darwin = "289ef1e335034000adca36b082f42fc2d2aa2a59a45f8c8ba15cd8616005b0ee";
    i686-linux = "da6f1ec2a364b7bbd91430374dd2ee0171ba3859f17009790ac6242f9dabb765";
    armv7l-linux = "9647488069c489293b4a4842a5a94c00cdf18702fee448d67c078eb500651641";
    aarch64-linux = "3517a3c78d6d8c8d0494e9c68c738d9995f9de5f9844e5ea2013ebda8f184394";
  };
}
