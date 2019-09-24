{ stdenv, rustPlatform, fetchFromGitHub, fetchpatch, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.17";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/r${version}";
    sha256 = "0slibycy4pfsnk7wyvi7rnfch7xqfyh8sjbw1x9qcmx65f3xgdd6";
  };

  cargoSha256 = "0db4j6y43gacazrvcmq823fzl5pdfdlg8mkjpysrw6h9fxisq83f";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xsl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make -j$NIX_BUILD_CORES
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-error=sign-compare" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-Wno-error=format-security";

  doCheck = true;

  checkPhase = ''
    make test -j$NIX_BUILD_CORES
  '';

  postInstall = ''
    make prefix="$out" install
    cp -r contrib $out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://newsboat.org/;
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
