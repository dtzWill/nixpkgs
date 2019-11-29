{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "subsonic";
  version = "6.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/subsonic/subsonic-${version}-standalone.tar.gz";
    sha256 = "180qdk8mnc147az8v9rmc1kgf8b13mmq88l195gjdwiqpflqzdyz";
  };

  inherit jre;

  # Create temporary directory to extract tarball into to satisfy Nix's need
  # for a directory to be created in the unpack phase.
  unpackPhase = ''
    runHook preUnpack
    mkdir ${name}
    tar -C ${name} -xzf $src
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r ${name}/* $out
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://subsonic.org;
    description = "Personal media streamer";
    license = licenses.unfree;
    maintainers = with maintainers; [ telotortium ];
    platforms = platforms.unix;
  };

  phases = ["unpackPhase" "installPhase"];
}
