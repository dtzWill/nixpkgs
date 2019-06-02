{ stdenv, fetchurl, pkgconfig, qmake, qtdeclarative, qtscript, qtsvg, dbus }:

stdenv.mkDerivation rec {
  pname = "vym";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0lyf0m4y5kn5s47z4sg10215f3jsn3k1bl389jfbh2f5v4srav4g";
  };

  # Data manages to end up under $out/vym by default,
  # instead of $out/share/... .  The result of this flag
  # is that the data goes in $out/share/vym, which
  # isn't perfect but fixing seems painful and this is an application
  # not an icon theme or something.... it's unlikely any
  # unconventional locations are problematic,
  # and certianly overall will be less "unexpected".
  # This is almost entirely moot however since this is an application
  # not an icon theme and so almost certianly has no users
  # that care about these things.
  #
  # ... But $out/vym needed to be fixed :).
  #
  # Hardcoded paths scattered about all have form share/vym
  # which is encouraging, although we'll need to patch them (below).
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

  meta = with stdenv.lib; {
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
