{ fetchurl, mkDerivation, lib, pkgconfig, python, file, bc, fetchpatch
, qtbase, qtsvg, hunspell
}:

mkDerivation rec {
  version = "2.3.3";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.3.x/${name}.tar.xz";
    sha256 = "0faf5028pdp42k6m9xd97ymim5xx370qlgv9lxvd50djvpmyy7lr";
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    qtbase qtsvg python file/*for libmagic*/ bc
    hunspell # enchant
  ];

  configureFlags = [
    "--enable-qt5"
    #"--without-included-boost"
    /*  Boost is a huge dependency from which 1.4 MB of libs would be used.
        Using internal boost stuff only increases executable by around 0.2 MB. */
    #"--without-included-mythes" # such a small library isn't worth a separate package
  ];

  enableParallelBuilding = true;
  doCheck = true;

  # python is run during runtime to do various tasks
  qtWrapperArgs = [
    ''--prefix PATH : "${python}/bin"''
  ];

  meta = with lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = http://www.lyx.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}

