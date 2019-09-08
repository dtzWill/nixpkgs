{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2019-09-04";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    #rev = "refs/tags/${builtins.replaceStrings ["-"][""] version}";
    rev = "6ddb9d9704e2171d91439c9c42c5965bf3863de8";
    sha256 = "0am2mmm8jqxc0dcag37swwgxjdg2dcf3schmlqmpmap9156m10il";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0z57r2rnlmdi04vzg2nfzkynpq2qjf5lvib29cqk64n5zl25hrgn";

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
