{ stdenv, fetchFromGitHub, which, utillinux }:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "unstable-2019-12-23";

  #src = fetchurl {
  #  url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
  #  sha256 = "16k0zwx5njmmbzkqkyl1xrsx2ykb0j35ygz39wc9s48j9kqhmdvz";
  #};
  src = fetchFromGitHub {
    owner = "tj";
    repo = pname;
    rev = "6438dee914172218f35684e0d275be51e5ec2f7d";
    sha256 = "07lxkbpxmr67wixpqcv1d5xd70f7l1pm4jf2dm5d87cb9y56s6aj";
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
