{ stdenv, fetchFromGitHub, makeWrapper
# runtime deps, adhoc
, git, python3, ruby, zsh, coreutils, runtimeShell }:


let
  path = stdenv.lib.makeBinPath [ git python3 ruby zsh coreutils runtimeShell ];
in stdenv.mkDerivation rec {
  pname = "git-extra-commands";
  version = "unstable-2019-09-28";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = pname;
    rev = "b642d37ed98d15e348b1f038c3ed627d5faa6e80";
    sha256 = "144x1p723g1rdkf8rr1xhzkyk1xmfmycr2rdw88dxrg6nk1aq7zb";
  };

  patches = [ ./completion.patch ];

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace bin/git-flush --replace /bin/rm ${coreutils}/bin/rm
  '';

  installPhase = ''
    install -Dm644 ${pname}.plugin.zsh $out/share/zsh/plugins/${pname}/${pname}.plugin.zsh

    mv bin $out/bin

    PATH=${path}:$PATH patchShebangs $out/bin
    for x in $out/bin/*; do
      wrapProgram $x --prefix PATH : ${path}
    done
  '';

  meta.priority = 100;
}

