{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fyzvl4hgschydy7h3cbrz1r1mas550cknlp4y5ky1jdv7h6rp0y";
  };

  nativeBuildInputs = [ cmake ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-Wno-nullability-extension"
    "-Wno-typedef-redefinition"
  ];

  # TODO: setup-hook?
  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isMusl "-lexecinfo";

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = https://github.com/awslabs/aws-c-common;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
