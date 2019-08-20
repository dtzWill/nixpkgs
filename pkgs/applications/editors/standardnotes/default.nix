{ stdenv, appimageTools, fetchurl }:

let
  version = "3.0.15";

  plat = {
    "i686-linux" = "i386";
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "0v2nsis6vb1lnhmjd28vrfxqwwpycv02j0nvjlfzcgj4b3400j7a";
    "x86_64-linux" = "130n586cw0836zsbwqcz3pp3h0d4ny74ngqs4k4cvfb92556r7xh";
  }.${stdenv.hostPlatform.system};
in appimageTools.wrapType2 rec {
  name = "standardnotes-${version}";

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-${plat}.AppImage";
    inherit sha256;
  };

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;

  # TODO: Why the upstream difference?
####
####  buildInputs = [ appimage-run ];
####
####  dontUnpack = true;

  extraInstallCommands = "ln -s $out/bin/${name} $out/bin/standardnotes";

  meta = with stdenv.lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = https://standardnotes.org;
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
