{ lib, fetchFromGitHub, python3Packages, gtk3, gobject-introspection, ffmpeg, which, wrapGAppsHook, gsettings-desktop-schemas, librsvg }:

with python3Packages;
buildPythonApplication rec {
  pname = "gnomecast";
  version = "1.7.1-git";

  src = fetchFromGitHub {
    owner = "keredson";
    repo = pname;
    rev = "3ff24dbea65197c405391ffe6604c19084fb8e46";
    sha256 = "0zmnpr98g4vjd3r13780glwfff02qhp8r4zd7w6cdjbq9hyk0mkw";
  };
  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "0hss7m9chqjhdzbvxs8kr312izb5diz85nfv7c050gpslk5mkr0v";
  #};

  nativeBuildInputs = [ wrapGAppsHook gsettings-desktop-schemas librsvg ];
  propagatedBuildInputs = [
    PyChromecast bottle pycaption paste html5lib pygobject3 dbus-python
    gtk3 gobject-introspection
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg which ]})
  '';

  meta = with lib; {
    description = "A native Linux GUI for Chromecasting local files";
    homepage = https://github.com/keredson/gnomecast;
    license = with licenses; [ gpl3 ];
  };
}
