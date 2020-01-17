{ stdenv, lib, fetchurl, perl, busybox, dmidecode }:
# busybox: cat grep id sed uname which

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.20";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/${pname}/files/${pname}-${version}.tar.gz";
    sha256 = "1s0hg5w47gmnllbs935bx21k3zqrgvqx1wn0zzij2lfxkb9dq4zr";
  };

  nativeBuildInputs = [ perl /* pod2man, for man pages */ ];

  # The tool is more effective when it has some optinal tools
  postPatch = ''
    substituteInPlace virt-what.in \
      --replace ':''${PATH}"' \
                ':${stdenv.lib.makeBinPath [ busybox dmidecode ]}:''${PATH}"'
  '';

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
