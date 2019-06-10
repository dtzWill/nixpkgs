{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "09fwhbcpp84l5lw4zizm46ssri6irzvjx2w7507a1xhp6iq73p2d";
  };

  modSha256 = "0n5j4rns2w1klgrf5jz0bng9cih9aifjx55hhkf4dfj1x4wsxjdj";

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X miniflux.app/version.Version=${version}
  '';

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}

