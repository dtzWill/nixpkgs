{ stdenv, fetchFromGitHub, which, utillinux }:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "unstable-2020-01-15";

  #src = fetchurl {
  #  url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
  #  sha256 = "16k0zwx5njmmbzkqkyl1xrsx2ykb0j35ygz39wc9s48j9kqhmdvz";
  #};
  src = fetchFromGitHub {
    owner = "tj";
    repo = pname;
    rev = "b708a8a4d39644e1d305c223d5063c07dd4bcc37";
    sha256 = "04y6pp2ib312zmb5b4xmq7j4cflcxrdrryppsws3nck2y3mvwxrc";
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
