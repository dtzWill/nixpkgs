{ stdenv
, lib
, fetchurl
, makeWrapper
, electron_5
, dpkg
, gtk3
, glib
, gsettings-desktop-schemas
, wrapGAppsHook
, withPandoc ? false
, pandoc
}:

stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.83";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "05skfqarfcmr17bvskd0yx3b421gym8fir720m4yv7i9bd1103pk";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar xvf -
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    {
      cd usr
      mv share/typora/resources/app $out/share/typora
      mv share/{applications,icons,doc} $out/share/
    }

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_5}/bin/electron $out/bin/typora \
      --add-flags $out/share/typora \
      "''${gappsWrapperArgs[@]}" \
      ${lib.optionalString withPandoc ''--prefix PATH : "${lib.makeBinPath [ pandoc ]}"''} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin worldofpeace ];
    platforms = [ "x86_64-linux"];
  };
}
