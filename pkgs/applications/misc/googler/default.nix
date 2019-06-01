{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "3.9";
  name = "googler-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "googler";
    rev = "v${version}";
    sha256 = "0zqq157i0rfrja8yqnqr9rfrp5apzc7cxb7d7ppv6abkc5bckyqc";
  };

  propagatedBuildInputs = [ python ];

  buildFlags = [ "disable-self-upgrade" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    cp auto-completion/bash/googler-completion.bash $out/share/bash-completion/completions/googler

    mkdir -p $out/share/zsh/site-functions
    cp auto-completion/zsh/_googler $out/share/zsh/site-functions/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jarun/googler;
    description = "Google Search, Google Site Search, Google News from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.unix;
  };
}
