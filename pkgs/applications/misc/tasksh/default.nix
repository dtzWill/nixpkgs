{ stdenv, fetchurl, cmake, git, readline, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tasksh";
  version = "2019-07-20";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskshell";
    rev = "6c80122d18993310e2939eeef1c34e1714d34635"; # 1.3.0, moving
    sha256 = "1az8r23lm1355rsgib2b84qd5a93vlgjfxx9ji53jwyk14zy18gf";
    fetchSubmodules = true;
    leaveDotGit = true; # depends on git version? :(
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
