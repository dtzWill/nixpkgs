{ lib, mkDerivation, fetchurl, fetchgit,
pkgconfig, qmake,
qtdeclarative, qtscript, qtsvg,
dbus,
# runtime dep
zip, unzip
# (on windows vym expects 7z instead)
}:

mkDerivation rec {
  pname = "vym";
  version = "unstable-2020-01-15";

  src = fetchgit {
    url = "git://git.code.sf.net/p/vym/code";
    rev = "e30abaad788aa8788aa4da05682777609c5d0054";
    sha256 = "1qp401jv6z02fgg0a37hwax1nyng7mqmyr59q500qkr39s2z2s0d";
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

    # bake in paths to zip/unzip to ensure they're avail
    substituteInPlace file.cpp \
      --replace '->start ("zip"' \
                '->start ("${zip}/bin/zip"' \
      --replace '->start ("unzip"' \
                '->start ("${unzip}/bin/unzip"'
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
