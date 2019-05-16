{stdenv, fetchFromGitLab , which, go-md2man, coreutils, substituteAll }:

stdenv.mkDerivation rec {
  version = "1.4.9";
  pname = "brillo";
  src = fetchFromGitLab {
    owner= "cameronnemo";
    repo= "brillo";
    rev= "v${version}";
    sha256 = "0ab7s60zcgl6hvm0a9rlwq35p25n3jnw6r9256pwl4cdwyjyybsb";
  };
  makeFlags = [ "PREFIX=$(out)" "AADIR=$(out)/etc/apparmor.d"];
  nativeBuildInputs = [go-md2man which];
  buildFlags = [ "dist" ];
  installTargets = [ "install-dist" "install.apparmor" ];
  patches = [
  (substituteAll {
    src = ./udev-rule.patch;
    inherit coreutils;
  }) ];

  meta = with stdenv.lib; {
    description = "Backlight and Keyboard LED control tool";
    homepage = https://gitlab.com/cameronnemo/brillo;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.alexarice ];
  };
}
