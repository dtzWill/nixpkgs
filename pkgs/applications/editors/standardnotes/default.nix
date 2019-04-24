{ stdenv, appimageTools, fetchurl }:

let
  version = "3.0.8";

  plat = {
    "i686-linux" = "i386";
    "x86_64-linux" = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "0v2nsis6vb1lnhmjd28vrfxqwwpycv02j0nvjlfzcgj4b3400j9a";
    "x86_64-linux" = "02rd7chpsfz3f19iv7dh9q3gpacjnm0mkfhrc8a0gjmz24jmyx2n";
  }.${stdenv.hostPlatform.system};
in

(appimageTools.wrapType2 rec {
  name = "standardnotes";
  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-${plat}.AppImage";
    inherit sha256;
  };
}).overrideAttrs(old: {
  name = "standardnotes-${version}";
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
})
