{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "glm";
  version = "0.9.9.3";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = pname;
    rev = version;
    sha256 = "1v6zcggym8vlykkykjchimahh7zd37ccgy41qpp6s4rxj2iqwjad";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "doc" ];


  # cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  doCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '"''${CMAKE_CURRENT_BINARY_DIR}/''${GLM_INSTALL_CONFIGDIR}' '"''${GLM_INSTALL_CONFIGDIR}'
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/glm
    cp -rv $NIX_BUILD_TOP/$sourceRoot/doc/* $doc/share/doc/glm
  '';

  meta = with stdenv.lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = http://glm.g-truc.net/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}

