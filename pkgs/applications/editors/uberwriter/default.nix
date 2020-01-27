{ stdenv, fetchFromGitHub, meson, ninja, cmake
, wrapGAppsHook, pkgconfig, desktop-file-utils
, appstream-glib, pythonPackages, glib, gobject-introspection
, gtk3, webkitgtk, glib-networking, gnome3, gspell, texlive
, haskellPackages}:

let
  pythonEnv = pythonPackages.python.withPackages(p: with p;
    [ regex setuptools python-Levenshtein pyenchant pygobject3 pycairo pypandoc ]);
  texliveDist = texlive.combined.scheme-medium;

in stdenv.mkDerivation rec {
  pname = "uberwriter";
  version = "unstable-2020-01-02";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "0d1da19ce8fe013b5abd6b227fbadc00f2d72b8c";
    sha256 = "186zhjh3l84cd67wmpn1s49fwisj0kxhv7592c06cl7lchmjx73m";
  };

  nativeBuildInputs = [ meson ninja cmake pkgconfig desktop-file-utils
    appstream-glib wrapGAppsHook ];

  buildInputs = [ glib pythonEnv gobject-introspection gtk3
    gnome3.adwaita-icon-theme webkitgtk gspell texliveDist
    glib-networking ];

  postPatch = ''
    patchShebangs --build build-aux/meson_post_install.py

    substituteInPlace uberwriter/config.py --replace "/usr/share/uberwriter" "$out/share/uberwriter"

    # get rid of unused distributed dependencies
    rm -r uberwriter/{pylocales,pressagio}
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/lib/python${pythonEnv.pythonVersion}/site-packages/"
      --prefix PATH : "${texliveDist}/bin"
      --prefix PATH : "${haskellPackages.pandoc-citeproc}/bin"
    )
  '';

  meta = with stdenv.lib; {
    homepage = http://uberwriter.github.io/uberwriter/;
    description = "A distraction free Markdown editor for GNU/Linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sternenseemann ];
  };
}
