{ lib, mkDerivation, fetchurl, fetchgit, pkgconfig, qmake, qtdeclarative, qtscript, qtsvg, dbus }:

mkDerivation rec {
  pname = "vym";
  version = "unstable-2019-09-18";

  src = fetchgit {
    url = "git://git.code.sf.net/p/vym/code";
    rev = "e1b695b9180baca7443ee5e1df6d7600cd3406bc";
    sha256 = "1pkyvva0k1g316whj44pa2i6lfb5b69074w2dmq4chvqikzjbj83";
  };
  #src = fetchurl {
  #  url = "mirror://sourceforge/project/${pname}/${version}/${pname}-${version}.tar.bz2";
  #  sha256 = "0lyf0m4y5kn5s47z4sg10215f3jsn3k1bl389jfbh2f5v4srav4g";
  #};

  qmakeFlags = [
    "DATADIR=${placeholder "out"}/share"
    "DOCDIR=${placeholder "out"}/share/doc/vym"
  ];

  postPatch = ''
    for x in \
      exportoofiledialog.cpp \
      main.cpp \
      mainwindow.cpp \
      tex/*.{tex,lyx}; \
    do
      substituteInPlace $x \
        --replace /usr/share/vym $out/share/vym \
        --replace /usr/local/share/vym $out/share/vym \
        --replace /usr/share/doc $out/share/doc/vym
    done
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtdeclarative qtscript qtsvg ];

  # TODO: package the various scripts, demos, examples
  # TODO: generate the pdf doc (hopefully any tex deps needed aren't too big)

  postInstall = ''
    install -Dm755 -t $out/share/man/man1 doc/*.1.gz
  '';

  dontGzipMan = true;

  meta = with lib; {
    description = "A mind-mapping software";
    longDescription = ''
      VYM (View Your Mind) is a tool to generate and manipulate maps which show your thoughts.
      Such maps can help you to improve your creativity and effectivity. You can use them
      for time management, to organize tasks, to get an overview over complex contexts,
      to sort your ideas etc.

      Maps can be drawn by hand on paper or a flip chart and help to structure your thoughs.
      While a tree like structure like shown on this page can be drawn by hand or any drawing software
      vym offers much more features to work with such maps.
    '';
    homepage = http://www.insilmaril.de/vym/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
