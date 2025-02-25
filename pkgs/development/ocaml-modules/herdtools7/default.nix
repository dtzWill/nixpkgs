{
  lib,
  buildDunePackage,
  replaceVars,
  fetchFromGitHub,
  menhir,
  menhirLib,
  zarith,
  coreutils,
  gnutar,
}:

buildDunePackage rec {
  pname = "herdtools7";
  version = "7.58";

  src = fetchFromGitHub {
    owner = "herd";
    repo = "herdtools7";
    rev = version;
    hash = "sha256-0+tyzuEPji/mCsN6ez4C+iJz5IroV3zAjVsbgG6lPJo=";
  };

  patches = [
    (replaceVars ./patch-command-paths.patch {
      inherit coreutils gnutar;
    })
  ];

  nativeBuildInputs = [ menhir ];
  buildInputs = [
    menhirLib
    zarith
  ];

  minimalOCamlVersion = "4.08";

  preBuild = ''
    make Version.ml
  '';

  postInstall = ''
    install -Dm644 -t $out/share/herdtools7/herd herd/libdir/*
    install -Dm644 -t $out/share/herdtools7/litmus litmus/libdir/*
    install -Dm644 -t $out/share/herdtools7/jingle jingle/libdir/*
  '';

  meta = with lib; {
    homepage = https://github.com/herd/herdtools7;
    description = "The Herd toolsuite to deal with .cat memory models";
    license = [ licenses.cecill-b ];
    maintainers = [ maintainers.dtzWill ];
  };
}
