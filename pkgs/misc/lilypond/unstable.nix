{ fetchgit, lilypond, ghostscript, gyre-fonts }:

let

  version = "2.19.84";

in

lilypond.overrideAttrs (oldAttrs: {
  inherit version;

  src = fetchgit {
    url = "https://git.savannah.gnu.org/r/lilypond.git";
    rev = "release/${version}-1";
    sha256 = "15wxya18larvy0ya97gg1xlbcd03cbl9n47xq53w9wjamh498hkv";
  };

  configureFlags = [
    "--disable-documentation"
    "--with-urwotf-dir=${ghostscript}/share/ghostscript/fonts"
    "--with-texgyre-dir=${gyre-fonts}/share/fonts/truetype/"
  ];
})
