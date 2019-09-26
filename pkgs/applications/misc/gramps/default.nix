{ stdenv, fetchFromGitHub, gtk3, pythonPackages, intltool, gnome3,
  pango, gobject-introspection, wrapGAppsHook, gettext,
# Optional packages:
 enableOSM ? true, osm-gps-map,
 enableGraphviz ? true, graphviz,
 enableGhostscript ? true, ghostscript,
 # For testing
 glibcLocales,
 }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "5.1.1";
  pname = "gramps";

  nativeBuildInputs = [ wrapGAppsHook gettext ];
  buildInputs = [ intltool gtk3 gobject-introspection pango gnome3.gexiv2 ] 
    # Map support
    ++ stdenv.lib.optional enableOSM osm-gps-map
    # Graphviz support
    ++ stdenv.lib.optional enableGraphviz graphviz
    # Ghostscript support
    ++ stdenv.lib.optional enableGhostscript ghostscript
    
  ;

  src = fetchFromGitHub {
    owner = "gramps-project";
    repo = "gramps";
    rev = "v${version}";
    sha256 = "1zrvr543zzsiapda75vdd2669fgijmx4cv7nfj5d1jsyz4qnif7b";
  };

  pythonPath = with pythonPackages; [
    bsddb3 PyICU pygobject3 pycairo
    # for tests
    lxml jsonschema mock
  ];

  # Same installPhase as in buildPythonApplication but without --old-and-unmanageble
  # install flag.
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
        # move colliding easy_install.pth to specifically named one
        mv "$eapth" $(dirname "$eapth")/${pname}-${version}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  checkInputs = [ glibcLocales ];
  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "Genealogy software";
    homepage = https://gramps-project.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ joncojonathan ];
  };
}
