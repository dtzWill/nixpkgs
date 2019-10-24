{ lib, fetchFromGitHub, python3Packages, gtk3, gobject-introspection, ffmpeg, which, wrapGAppsHook, gsettings-desktop-schemas, librsvg }:

with python3Packages;
buildPythonApplication rec {
  pname = "gnomecast";
  version = "1.9.5";

  #src = fetchFromGitHub {
  #  owner = "keredson";
  #  repo = pname;
  #  rev = "3ff24dbea65197c405391ffe6604c19084fb8e46";
  #  sha256 = "0zmnpr98g4vjd3r13780glwfff02qhp8r4zd7w6cdjbq9hyk0mkw";
  #};
  src = fetchPypi {
    inherit pname version;
    sha256 = "016hvj6yham773hm59az8zhlz7azxy3fl9spkacjbi62zgn2qqa2";
  };

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
