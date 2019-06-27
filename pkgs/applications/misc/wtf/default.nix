{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m0hrn1iqikp2pc16264ibsdw3nra4ba8r711mn1r2n15241x03v";
  };

  modSha256 = "0as736nnx7ci4w9gdp27g55g6dny9bh1fryz3g89gxm2sa2nlb9l";

  buildFlagsArray = [ "-ldflags=" "-X main.version=${version}" ];

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = http://wtfutil.com/;
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
