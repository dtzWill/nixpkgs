{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, xercesc
, qtbase, qttools, qtwebengine, qtxmlpatterns
, python3, python3Packages
}:

mkDerivation rec {
  name = "sigil-${version}";
  version = "0.9.18";

  src = fetchFromGitHub {
    sha256 = "0940g8nw2vid9i136r1d26641hvwvsy8sxpzki2fnc6ph4rfdqf8";
    rev = version;
    repo = "Sigil";
    owner = "Sigil-Ebook";
  };

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [
    boost xercesc qtbase qttools qtwebengine qtxmlpatterns
    python3Packages.lxml ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = https://github.com/Sigil-Ebook/Sigil/;
    license = licenses.gpl3;
    # currently unmaintained
    platforms = platforms.linux;
  };
}
