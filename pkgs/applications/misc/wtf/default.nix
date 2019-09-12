{ buildGoModule
, fetchFromGitHub
, lib
, which
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "03k3x3fnxz23b75n5x8mlr6srr063q3dwq05wh55b4bgqsf7lgzd";
  };

  modSha256 = "1nqnjpkrjbb75yfbzh3v3vc4xy5a2aqm9jr40hwq589a4l9p5pw2";

  # buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ which ];

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
