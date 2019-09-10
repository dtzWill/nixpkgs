{ version, sha256, extraPreConfigure ? null }:
{ lib, mkDerivation, fetchFromGitHub, qtbase, qmake }:

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
  nativeBuildInputs = [ qmake ];

  preConfigure = ''
    export qmakeFlags="$qmakeFlags uefitool.pro"
    ${lib.optionalString (extraPreConfigure != null) extraPreConfigure}
  '';

  installPhase = ''
    mkdir -p "$out"/bin
    cp UEFITool "$out"/bin
  '';

  meta = with lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = https://github.com/LongSoft/uefitool;
    license = licenses.bsd2;
    maintainers = with maintainers; [ ajs124 ];
    platforms = platforms.all;
  };
}
