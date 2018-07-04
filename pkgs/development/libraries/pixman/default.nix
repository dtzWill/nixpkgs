{ stdenv, fetchurl, fetchpatch, autoconf, automake, libtool, autoreconfHook, pkgconfig, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  name = "pixman-${version}";
  version = "0.34.0";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${name}.tar.bz2";
    sha256 = "184lazwdpv67zrlxxswpxrdap85wminh1gmq1i5lcz6iycw39fir";
  };

  patches = [
    (fetchpatch {
      name = "float-h-include.patch";
      url = "https://cgit.freedesktop.org/pixman/patch/?id=7c6066b700c7cdd4aeb8be426b14b3a5f0de4b6c";
      sha256 = "13vpk9x495f79ygq6kvfkh90xzvyby39g5pbmc854416pajnps43";
    })
    (fetchpatch {
      name = "fix-UB-int-promotion.patch";
      url = "https://cgit.freedesktop.org/pixman/patch/?id=8b95e0e460baa499e54c19d29bf761d34c25badc";
      sha256 = "11bwzazg0ngq36ncr89s3cm0r967zm8ng8s1wfn32q03c3l6r4hv";
    })
  ] ++ stdenv.lib.optionals stdenv.cc.isClang [
    (fetchpatch {
      name = "builtin-shuffle.patch";
      url = https://patchwork.freedesktop.org/patch/177506/raw;
      sha256 = "0rvraq93769dy2im2m022rz99fcdxprgc2fbmasnddcwrqy1x3xr";
    })
  ] ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      name = "stacksize-reduction.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/pixman/stacksize-reduction.patch?id=54895584e63afb61550cbd3212aa221e98ac8fc1";
      sha256 = "086qvlaqzgicbml9j0j52xqcf8bzifc8y4h4prd512a3hv9lxqsh";
    })
  ];

  nativeBuildInputs = [ pkgconfig ]
    ++ stdenv.lib.optionals stdenv.cc.isClang [ autoconf automake libtool autoreconfHook ];

  buildInputs = [ libpng ];

  configureFlags = stdenv.lib.optional stdenv.isAarch32 "--disable-arm-iwmmxt";

  doCheck = true;

  postInstall = glib.flattenInclude;

  meta = with stdenv.lib; {
    homepage = http://pixman.org;
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
