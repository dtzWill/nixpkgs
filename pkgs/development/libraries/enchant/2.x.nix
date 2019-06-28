{ stdenv, fetchurl, aspell, pkgconfig, glib, hunspell, hspell, unittest-cpp }:

let
  version = "2.2.4";
  pname = "enchant";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://github.com/AbiWord/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1p6a3qmrh8bjzds6x7rg9da0ir44gg804jzkf634h39wsa4vdmpm";
  };

  configureFlags = [ "--enable-relocatable" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib hunspell ];
  propagatedBuildInputs = [ hspell aspell ]; # libtool puts it to la file

  checkInputs = [ unittest-cpp ];
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Generic spell checking library";
    homepage = https://abiword.github.io/enchant/;
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
