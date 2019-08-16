{ stdenv, buildPythonPackage , fetchFromGitHub
, bashInteractive , urlgrabber, m2crypto
}:

buildPythonPackage rec {
  pname = "osc";
  version = "0.165.4";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
    sha256 = "1f8q65wlgchzwzarwrv6a0p60gw0ykpf4d5s7cks835hyawgcbyl";
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  propagatedBuildInputs = [ urlgrabber m2crypto ];

  doCheck = false;

  postInstall = ''
    ln -s $out/bin/osc-wrapper.py $out/bin/osc
    install -D -m444 osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 dist/osc.complete $out/share/bash-completion/helpers/osc-helper
    mkdir -p $out/share/bash-completion/completions
    cat >>$out/share/bash-completion/completions/osc <<EOF
    test -z "\$BASH_VERSION" && return
    complete -o default _nullcommand >/dev/null 2>&1 || return
    complete -r _nullcommand >/dev/null 2>&1         || return
    complete -o default -C $out/share/bash-completion/helpers/osc-helper osc
    EOF
  '';

  meta = with stdenv.lib; {
    description = "opensuse-commander with svn like handling";
    maintainers = [ maintainers.peti ];
    license = licenses.gpl2;
  };

}
