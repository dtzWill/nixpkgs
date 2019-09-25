{ stdenv, fetchFromGitHub, fetchpatch, cmake, shared ? false }:

stdenv.mkDerivation rec {
  pname = "pugixml";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    rev = "v${version}";
    sha256 = "0bpliqha1gic6j5wy5x5np90nr3ibax4q9gdvy8ncy2748njfb3p";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}" ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = with stdenv.lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = https://pugixml.org;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
