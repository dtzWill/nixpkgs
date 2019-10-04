{ stdenv, fetchFromGitHub, cmake, pkgconfig, gettext, libcsptr, dyncall, nanomsg}:

stdenv.mkDerivation rec {
  name = "boxfort";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "BoxFort";
    rev = "926bd4ce968592dbbba97ec1bb9aeca3edf29b0d";
    sha256 = "0mzy4f8qij6ckn5578y3l4rni2470pdkjy5xww7ak99l1kh3p3v6";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig gettext libcsptr dyncall nanomsg ];

  cmakeFlags = [ "-DBXF_TESTS=OFF" "-DBXF_SAMPLES=OFF" "-DBXF_FORK_RESILIENCE=OFF" ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = licenses.mit;
    maintainers = with maintainers; [ Yumasi ];
    platforms = platforms.unix;
  };
}
