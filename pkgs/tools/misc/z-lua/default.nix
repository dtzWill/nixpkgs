{ stdenv, fetchFromGitHub, lua }:

let
  lualfs = lua.withPackages (p: with p; [ luafilesystem ]);
in stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = "v${version}";
    sha256 = "0cn38sadcn65pgw6dgr59bnx9hf97011hydmpmfi3kzdqjmarwci";
  };

  # May not be desirable for everyone
  patches = [
    ./0001-allow-env-vars-to-customize-min-rank-and-scaling-fac.patch
    ./0001-better-hyphen-fix.patch
  ];

  dontBuild = true;

  postPatch = ''
    substituteInPlace z.lua --replace \
      '.. os.interpreter() ..' \
      '.. "${lualfs}/bin/lua" ..'
  '';

  buildInputs = [ lualfs ];

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
