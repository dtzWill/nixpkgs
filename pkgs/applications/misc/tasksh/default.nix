{ stdenv, fetchurl, cmake, git, readline, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tasksh";
  version = "2019-07-20";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskshell";
    rev = "6c80122d18993310e2939eeef1c34e1714d34635"; # 1.3.0, moving
    sha256 = "1czkck1731j8b321kjl697d7nz889ph63j4as7ihzwkzz6y1m4m0";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  buildInputs = [ readline ];
  nativeBuildInputs = [ cmake git ];

  preConfigure = "touch .git/index";

  meta = with stdenv.lib; {
    description = "REPL for taskwarrior";
    homepage = http://tasktools.org;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
