{ stdenv, fetchFromGitHub, pkgconfig, libsoup, webkitgtk, gtk3, glib-networking
, gsettings-desktop-schemas, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "vimb";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "fanglingsu";
    repo = "vimb";
    rev = version;
    sha256 = "13q7mk1hhjri0s30a98r8ncy0skf6m6lrnbqaf0jimf6sbwgiirf";
  };

  postPatch = ''
    mkdir -p .git && touch .git/index
  '';

  nativeBuildInputs = [ wrapGAppsHook pkgconfig ];
  buildInputs = [ gtk3 libsoup webkitgtk glib-networking gsettings-desktop-schemas ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "A Vim-like browser";
    longDescription = ''
      A fast and lightweight vim like web browser based on the webkit web
      browser engine and the GTK toolkit. Vimb is modal like the great vim
      editor and also easily configurable during runtime. Vimb is mostly
      keyboard driven and does not detract you from your daily work.
    '';
    homepage = https://fanglingsu.github.io/vimb/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
