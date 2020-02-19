{ stdenv, pkgconfig, fetchFromGitHub, libbsd, bmake, curl }:

stdenv.mkDerivation rec {
  pname = "kcgi";
  version = "0.10.13";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "18idyqa798y0yna462d0pd5j87810h7brqzsijw1jmnv8agk7xz6";
  };
  patchPhase = ''
    substituteInPlace configure --replace /usr/local /
    substituteInPlace Makefile --replace /bin/echo echo
  '';
  
  nativeBuildInputs = [ bmake pkgconfig ];
  buildInputs = [ curl ] ++ stdenv.lib.optionals stdenv.isLinux [ libbsd ] ;

  buildPhase = ''
    runHook preBuild
    bmake
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    bmake regress
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    bmake DESTDIR=${placeholder "out"} install
    runHook postInstall
  '';

  dontAddPrefix = true;

  meta = with stdenv.lib; {
    homepage = https://kristaps.bsd.lv/kcgi;
    description = "Minimal CGI and FastCGI library for C/C++";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.leenaars ];
  };
}
