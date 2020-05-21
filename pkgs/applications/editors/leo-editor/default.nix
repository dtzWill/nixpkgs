{ lib, mkDerivation, python3, fetchFromGitHub, makeWrapper, makeDesktopItem }:

let
  py = python3.withPackages (ps: with ps; [
    pyqt5 docutils
    # meta
    pyenchant
    # shortcutter # desktop integration
    # flexx # LeoWapp
    sphinx # rST plugin
    nbformat # Jupyter integration
  ]);
in
mkDerivation rec {
  pname = "leo-editor";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "leo-editor";
    repo = "leo-editor";
    rev = version;
    sha256 = "07f10qwvi3p7bskzxnx5rlhlfrh7rx8v0xdlc4vs2271438j1j2z";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper py ];
  propagatedBuildInputs = with python3.pkgs; [
    pyqt5 docutils
    # meta
    pyenchant
    # shortcutter # desktop integration
    # flexx # LeoWapp
    sphinx # rST plugin
    nbformat # Jupyter integration
  ];

  desktopItem = makeDesktopItem rec {
    name = "leo-editor";
    exec = "leo %U";
    icon = "leoapp32";
    type = "Application";
    comment = meta.description;
    desktopName = "Leo";
    genericName = "Text Editor";
    categories = lib.concatStringsSep ";" [
      "Application" "Development" "IDE" "QT"
    ];
    startupNotify = "false";
    mimeType = lib.concatStringsSep ";" [
      "text/plain" "text/asp" "text/x-c" "text/x-script.elisp" "text/x-fortran"
      "text/html" "application/inf" "text/x-java-source" "application/x-javascript"
      "application/javascript" "text/ecmascript" "application/x-ksh" "text/x-script.ksh"
      "application/x-tex" "text/x-script.rexx" "text/x-pascal" "text/x-script.perl"
      "application/postscript" "text/x-script.scheme" "text/x-script.guile" "text/sgml"
      "text/x-sgml" "application/x-bsh" "application/x-sh" "application/x-shar"
      "text/x-script.sh" "application/x-tcl" "text/x-script.tcl" "application/x-texinfo"
      "application/xml" "text/xml" "text/x-asm"
    ];
  };

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p "$out/share/icons/hicolor/32x32/apps"
    cp leo/Icons/leoapp32.png "$out/share/icons/hicolor/32x32/apps"

    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications

    mkdir -p $out/share/leo-editor
    mv * $out/share/leo-editor

    makeWrapper ${py.interpreter} $out/bin/leo \
      --prefix PYTHONPATH : "$out/share/leo-editor" \
      --add-flags "-O $out/share/leo-editor/launchLeo.py" \
      --prefix PATH : ${py}/bin \
      ''${qtWrapperArgs[@]}

      patchShebangs $out
  '';

  meta = with lib; {
    homepage = "http://leoeditor.com";
    description = "A powerful folding editor";
    longDescription = "Leo is a PIM, IDE and outliner that accelerates the work flow of programmers, authors and web designers.";
    license = licenses.mit;
    maintainers = with maintainers; [ leonardoce ramkromberg ];
  };
}
