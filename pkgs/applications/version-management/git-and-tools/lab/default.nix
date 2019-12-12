{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lab";
  version = "0.16.0-2019-08-15";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
#    rev = "v${version}";
    rev = "118fa13b3e0b66b0da346140246e59c1227886c9";
    sha256 = "0v51i9zcr4sw0icjh05saavlx2nybwfqg08pks7j3z2pra1ppx96";
  };

  subPackages = [ "." ];

  modSha256 = "0r36janm2386p8wa68b54h0mc5k162d84283zq3dp8v15iy29zgs";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    export LAB_CORE_HOST=a LAB_CORE_USER=b LAB_CORE_TOKEN=c
    $out/bin/lab completion bash > $out/share/bash-completion/completions/lab
    $out/bin/lab completion zsh > $out/share/zsh/site-functions/_lab
  '';

  meta = with stdenv.lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = https://zaquestion.github.io/lab;
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill ];
    platforms = platforms.all;
  };
}
