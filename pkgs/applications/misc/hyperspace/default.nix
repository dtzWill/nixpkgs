{ stdenv, fetchurl, lib
, autoPatchelfHook, wrapGAppsHook, dpkg
, atomEnv /* XXX: lazy */
}:

stdenv.mkDerivation rec {
  pname = "hyperspace";
  version = "1.0.0";
  src = fetchurl {
    url = "https://github.com/hyperspacedev/${pname}/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "09j54jjajsdwrc38xm00ydf5k4i3a7ib1pdzswb0lx68h89cdcaj";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -vx $src .
  '';

  installPhase = ''
    mkdir -p $out

    # /usr/share
    mv ./usr/* $out/

    # /opt/Hyperspace
    mv ./opt/Hyperspace $out/share/hyperspace

    mkdir -p $out/bin
    ln -s $out/share/hyperspace/hyperspace $out/bin/hyperspace
  '';

  buildInputs = /* FIXME: don't be lazy */ atomEnv.packages;

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    homepage = "https://hyperspace.marquiskurt.net";
    # license = # XXX: "non-violent" ?!
    maintainers = with maintainers; [ dtzWill ];
  };
}
