{ stdenv, fetchFromGitHub, which, utillinux }:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "unstable-2019-10-15";

  #src = fetchurl {
  #  url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
  #  sha256 = "16k0zwx5njmmbzkqkyl1xrsx2ykb0j35ygz39wc9s48j9kqhmdvz";
  #};
  src = fetchFromGitHub {
    owner = "tj";
    repo = pname;
    rev = "7bdfb1f55f247b4f876b97405ba88432ebc68446";
    sha256 = "1pwnq245xxxavahp4bcq31c1s2n9ai8a6bsqi9fimaxx04a0sxw0";
  };

  dontBuild = true;

  nativeBuildInputs = [ which ];
  buildInputs = [ utillinux ];

  postPatch = "patchShebangs ./check_dependencies.sh";

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  postInstall = ''
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
    install -D etc/bash_completion.sh $out/etc/bash-completion.d/git-extras
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt cko dtzWill ];
  };
}
