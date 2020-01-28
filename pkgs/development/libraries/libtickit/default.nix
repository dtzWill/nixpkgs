{ stdenv, fetchurl, unibilium, libtermkey, libtool, pkgconfig }:

stdenv.mkDerivation {
  pname = "libtickit";
  version = "0.3.4";

  src = fetchurl {
    url = "http://www.leonerd.org.uk/code/libtickit/libtickit-0.3.4.tar.gz";
    sha256 = "1qigh471ygjjxby97q03v4yd59vilyv7k5c7hjxj5b56jc1hpk4p";
  };

  nativeBuildInputs = [ libtool pkgconfig ];
  buildInputs = [ unibilium libtermkey ];

  makeFlags = [ "PREFIX=${placeholder "out"}" "DESTDIR=" ];

  meta = with stdenv.lib; {
    description = "Terminal Interface Construction Kit";
    homepage = "http://www.leonerd.org.uk/code/libtickit/";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
