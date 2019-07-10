{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "13izb0v0b30v0xv3yg082n0zsk4v57x6vx3m7ln4wril762ab784";
  };

  modSha256 = "0921d2qy0jcnih7hlda0i5q45b350yp9frh3hhh91f1g0j7vn1y6";

  buildFlagsArray = [ "-ldflags=" "-X main.version=${version}" ];

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = http://wtfutil.com/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
