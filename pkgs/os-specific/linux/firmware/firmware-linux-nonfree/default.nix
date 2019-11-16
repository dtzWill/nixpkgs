{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "2019-11-13";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    #rev = "refs/tags/${builtins.replaceStrings ["-"][""] version}";
    rev = "c62c3c26a5e77585e20e1b2b0f10976c36d4e910";
    sha256 = "199p97zrf2gr68wmfik4rx5p7fy65w86pz4l63nrzynmlbngvs2a";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "153lis0pq3nr3wzfmppgxp60prd1g14kj595phibsm0ifibn5p6q";

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
