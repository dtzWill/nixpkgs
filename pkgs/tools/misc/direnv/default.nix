{ stdenv, fetchFromGitHub, buildGoPackage, bash }:

buildGoPackage rec {
  name = "direnv-${version}";
#  version = "2.20.1";
  version = "unstable-2019-12-13";
  goPackagePath = "github.com/direnv/direnv";

  src = fetchFromGitHub {
    owner = "direnv";
    repo = "direnv";
#    rev = "v${version}";
    rev = "c980189055f7d5aaae86436119a23fd955ef2295";
    sha256 = "1827mjzwafxqcfsh8qs72mxsp183kp2q52sgb19njxp4675k5d4w";
  };

  postConfigure = ''
    cd $NIX_BUILD_TOP/go/src/$goPackagePath
  '';

  # we have no bash at the moment for windows
  makeFlags = stdenv.lib.optional (!stdenv.hostPlatform.isWindows) [
    "BASH_PATH=${bash}/bin/bash"
  ];

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$bin
    mkdir -p $bin/share/fish/vendor_conf.d
    echo "eval ($bin/bin/direnv hook fish)" > $bin/share/fish/vendor_conf.d/direnv.fish
  '';

  meta = with stdenv.lib; {
    description = "A shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = https://direnv.net;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
