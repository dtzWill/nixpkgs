{ stdenv, fetchFromGitHub, lua }:

stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = "v${version}";
    sha256 = "17klcw2iv7d636mp7fb80kjvqd3xqkzqhwz41ri1l029dxji4zzh";
  };

  # May not be desirable for everyone
  patches = [
    ./0001-escape-patterns-fix-hyphen-behavior-but-lose-lua-reg.patch
    ./0002-escape-just-hyphens-as-quickfix-compromise.patch
    ./0001-allow-env-vars-to-customize-min-rank-and-scaling-fac.patch
  ];

  dontBuild = true;

  buildInputs = [ lua ];

  installPhase = ''
    install -Dm755 z.lua $out/bin/z
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/skywind3000/z.lua;
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
