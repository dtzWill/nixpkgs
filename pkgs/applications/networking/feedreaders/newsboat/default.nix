{ stdenv, rustPlatform, fetchurl, fetchFromGitHub, fetchpatch, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoc, docbook_xml_dtd_45, libxslt, docbook_xsl, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  #name = "newsboat-${version}";
  pname = "newsboat";
#  version = "2.15";
  version = "2019-06-06";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "80402ef7726f063e982170977a03f1f143cdfa11";
    sha256 = "1z2pn92zhzv8zs5ky9j296gml8km2qyz1z0j7gjpamgq9n6m4iv8";
  };
  #src = fetchurl {
  #  url = "https://newsboat.org/releases/${version}/${name}.tar.xz";
  #  sha256 = "1dqdcp34jmphqf3d8ik0xdhg0s66nd5rky0y8y591nidq29wws6s";
  #};

  cargoSha256 = "0ck2dgfk4fay4cjl66wqkbnq4rqrd717jl63l1mvqmvad9i19igm";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [ pkgconfig asciidoc docbook_xml_dtd_45 libxslt docbook_xsl ]
    ++ stdenv.lib.optional stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl gettext libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make -j$NIX_BUILD_CORES
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

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
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console.";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
