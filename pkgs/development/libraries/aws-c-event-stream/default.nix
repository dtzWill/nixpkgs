{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, aws-checksums, libexecinfo }:

stdenv.mkDerivation rec {
  pname = "aws-c-event-stream";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "10652dp4q00n3qisw0729ka76j21linq34c43daqmdm8q3nl142d";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common aws-checksums ] ++ lib.optional stdenv.hostPlatform.isMusl libexecinfo;

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  # TODO: setup-hook?
  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isMusl "-lexecinfo";

  meta = with lib; {
    description = "C99 implementation of the vnd.amazon.eventstream content-type";
    homepage = https://github.com/awslabs/aws-c-event-stream;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
