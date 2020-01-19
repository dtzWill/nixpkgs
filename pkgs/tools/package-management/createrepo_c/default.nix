{ stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, expat, glib, curl, libxml2, python3, rpm, openssl, sqlite, file, xz, pcre, bash-completion }:

stdenv.mkDerivation rec {
  pname = "createrepo_c";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "createrepo_c";
    rev    = version;
    sha256 = "1hijl7kdb7p4a211sd0dix9n8a071d6y3fv837nnpk4kfmjrzli4";
  };

  patches = [
    ./fix-python-install-path.patch
  ];

  postPatch = ''
    substituteInPlace src/python/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python3.sitePackages}"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ bzip2 expat glib curl libxml2 python3 rpm openssl sqlite file xz pcre bash-completion ];

  meta = with stdenv.lib; {
    description = "C implementation of createrepo";
    homepage    = "http://rpm-software-management.github.io/createrepo_c/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

