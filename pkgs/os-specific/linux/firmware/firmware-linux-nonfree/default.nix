{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2019-10-14";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    #rev = "refs/tags/${builtins.replaceStrings ["-"][""] version}";
    rev = "4c3e853c757c5df035e72ee7203124e54230d74c";
    sha256 = "08kccjhlq39k08j0xw1a8i36vlhymlq7z17gawi196l1pkf33bzb";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1a88zawhiq5sqzgacv76scx3yr9x61f4w38h9rfdzqkcnkxvr078";

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
