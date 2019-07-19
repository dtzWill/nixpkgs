{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2019-07-17";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "refs/tags/${builtins.replaceStrings ["-"][""] version}";
    sha256 = "1ncn36b4gf24ljgf3pa2vh62h1iqa75fsjyhmqpcz7jln6i049pa";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "08svm87pzq7n1s9qxrcqz80pf758xfq718wh83c76kas7bsjfvjg";

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
