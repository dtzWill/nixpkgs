{ lib, mkDerivation, hostPlatform, fetchFromGitHub
, qmake, qtbase, qtscript, qtxmlpatterns, qtmacextras }:

mkDerivation rec {
  pname = "qcad";
  version = "3.23.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "16ihpr1j0z28zlmvr18zdnw4ba1wksq5rplmch2ffsk4ihg9d8k1";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtscript qtxmlpatterns ] ++ lib.optional hostPlatform.isDarwin qtmacextras;
}

