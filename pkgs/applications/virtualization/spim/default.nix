{ mkDerivation, lib, fetchsvn, qmake, qtbase, qttools, bison, flex, qtdeclarative }:

mkDerivation rec {
  pname = "QtSpim";
  version = "722";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code";
    rev = version;
    sha256 = "1hfz41ra93pdd2pri5hibl63sg9yyk12a8nhdkmgj7h9bwgqxw6b";
  };

  sourceRoot = "code-r${version}/QtSpim";

  nativeBuildInputs = [ bison flex qmake qttools ];

  buildInputs = [ qtbase ];

  # Remove build artefacts from the repo
  preConfigure = ''
    rm parser_yacc.h
    rm parser_yacc.cpp
    rm scanner_lex.cpp

    rm help/qtspim.qhc
  '';

  # Disable documentation building, because qtspim can't find compiled docs
#   patches = [ ./qtspim-disable-docs.patch ];

  # Commented out to save some build time (uncomment after fixing doc finding)
  # Fix bug in a generated Makefile
  postConfigure = ''
    substituteInPlace Makefile --replace '$(MOVE) help/qtspim.qhc help/qtspim.qhc;' ""
  '';

  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QT_QPA_PLATFORM_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}/platforms";
  #QML2_IMPORT_PATH = "${qtdeclarative.bin}/${qtbase.qtQmlPrefix}";

  #preBuild = ''
  #  ls -la
  #  chmod -R u+rw .
  #'';

  #buildPhase = ''
  #  make
  #'';

  installPhase = ''
    install -sDm0755 QtSpim $out/bin/qtspim

    install -D ../Documentation/qtspim.man $out/usr/share/man/man1/qtspim.1
    gzip -f --best $out/usr/share/man/man1/qtspim.1

    install -d $out/usr/share/qtspim

    # Don't copy compiled Qt docs till qtspim can find them
    install -Dm0644 help/qtspim.qch $out/usr/share/qtspim/help/qtspim.qch
    install -Dm0644 help/qtspim.qhc $out/usr/share/qtspim/help/qtspim.qhc

    # qtspim can't find Qt-format docs, so copy html docs
    mkdir -p $out/usr/share/qtspim/help
    cp help/*.jpg help/*.html $out/usr/share/qtspim/help

    install -Dm0644 ../Setup/qtspim_debian_deployment/qtspim.desktop $out/usr/share/applications/qtspim.desktop
    install -Dm0644 ../Setup/qtspim_debian_deployment/copyright $out/usr/share/licenses/qtspim/copyright
    install -Dm0644 ../Setup/NewIcon48x48.png $out/usr/share/qtspim/qtspim.png

    install -Dm0644 ../helloworld.s $out/usr/share/qtspim/helloworld.s
  '';

  enableParallelBuilding = false;

  meta = with lib; {
    description = "SPIM MIPS simulator";
    longDescription = ''
      SPIM is a self-contained simulator that runs MIPS32 assembly language programs. spim also provides a simple debugger and minimal set of operating system services.
    '';

    homepage = "https://sourceforge.net/projects/spimsimulator/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aske ];
  };
}
