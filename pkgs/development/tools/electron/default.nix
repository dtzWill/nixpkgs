{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core }@args:

let
  mkElectron = import ./generic.nix args;
in
{
  electron_4 = mkElectron "4.2.8";
  electron_5 = mkElectron "5.0.9";
  electron_6 = mkElectron "6.1.7";
  electron_7 = mkElectron "7.1.10";
}
