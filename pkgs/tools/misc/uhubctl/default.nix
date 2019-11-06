{ stdenv
, fetchFromGitHub
, libusb
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  #version = "2.1.0";
  version = "unstable-2019-11-04";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    #rev = "refs/tags/v${version}";
    rev = "3e10680f22134f8fab4e8be3564713f8c90c18ab";
    sha256 = "07pbg8gqrv0160gs3837aq197qr05d2833lmn537i3vqwydj37ng";
  };

  buildInputs = [ libusb ];

  installFlags = [ "prefix=${placeholder "out"}" ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak ];
    platforms = with platforms; linux ++ darwin;
  };
}
