{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, swig, pcsclite, PCSC }:

buildPythonPackage rec {
  version = "1.9.9";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "082cjkbxadaz2jb4rbhr0mkrirzlqyqhcf3r823qb0q1k50ybgg6";
  };

  postPatch = ''
    sed -e 's!"libpcsclite\.so\.1"!"${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so.1"!' \
        -i smartcard/scard/winscarddll.c
  '';

  NIX_CFLAGS_COMPILE = "-isystem ${stdenv.lib.getDev pcsclite}/include/PCSC/";

  patches = [
    # Fixes darwin tests
    # See: https://github.com/LudovicRousseau/pyscard/issues/77
    (fetchpatch {
      url = "https://github.com/LudovicRousseau/pyscard/commit/62e675028086c75656444cc21d563d9f08ebf8e7.patch";
      sha256 = "1lr55npcpc8j750vf7vaisqyk18d5f00l7nii2lvawg4sssjaaf7";
    })
  ];

  propagatedBuildInputs = [ pcsclite ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin PCSC;
  nativeBuildInputs = [ swig ];

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
