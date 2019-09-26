{ version, sha256, extraPreConfigure ? null }:
{ lib, mkDerivation, fetchFromGitHub, qtbase, qmake, cmake }:

mkDerivation rec {
  passthru = {
    inherit version;
    inherit sha256;
    inherit extraPreConfigure;
  };
  name = "uefitool-${version}";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "LongSoft";
    repo = "uefitool";
    rev = version;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake qmake ];

  dontUseQmakeConfigure = true;
  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs ./unixbuild.sh
    sed -i '/zip /d' ./unixbuild.sh
  '';
  # TODO: run hooks or don't override entire phase...?

  configurePhase = ''
    ./unixbuild.sh --configure
  '';
  buildPhase = ''
    ./unixbuild.sh --build
  '';

  installPhase = ''
    install -Dm755 -t $out/bin UEFITool/UEFITool UEFIExtract/UEFIExtract UEFIFind/UEFIFind
  '';

  meta = with lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = https://github.com/LongSoft/uefitool;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ajs124 ];
    platforms = platforms.all;
  };
}
