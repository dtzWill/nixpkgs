{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2019-11-08";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    #rev = "refs/tags/${builtins.replaceStrings ["-"][""] version}";
    rev = "f1100ddf581f49aa79a54b56fe6ef0815a7ae57e";
    sha256 = "1aj87121bqmd4mf7yd0mnnrz79y32w48vss4gqc9qrp87wxfhplx";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1w7avaxdqr4pyf8gj93rg95705qzpirmrs4xpg5qd406khk7y4hn";

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
