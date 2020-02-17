{ stdenv, fetchurl, fetchFromGitHub, lib
, cmake
, uthash, pkgconfig
, python3, freetype, zlib, glib, libungif, libpng, libjpeg, libtiff, libxml2, cairo, pango
, readline, woff2, zeromq
, withSpiro ? false, libspiro
, withGTK ? false, gtk3
, withPython ? true
, withExtras ? true
, Carbon ? null, Cocoa ? null
}:

stdenv.mkDerivation rec {
  pname = "fontforge";
  version = "2020-02-14";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = "46704cc75744965c7d11a434332f8e4a81d42bfc";
    sha256 = "0f9i8cvzh1dyw4xrb60vvjzqlrn4by1anfp1sxmmrnaizw6jzm3r";
  };

  #patches = [ ./fontforge-20140813-use-system-uthash.patch ];

  # use $SOURCE_DATE_EPOCH instead of non-deterministic timestamps
  postPatch = ''
    find . -type f -name '*.c' -exec sed -r -i 's#\btime\(&(.+)\)#if (getenv("SOURCE_DATE_EPOCH")) \1=atol(getenv("SOURCE_DATE_EPOCH")); else &#g' {} \;
    sed -r -i 's#author\s*!=\s*NULL#& \&\& !getenv("SOURCE_DATE_EPOCH")#g'                            fontforge/cvexport.c fontforge/dumppfa.c fontforge/print.c fontforge/svg.c fontforge/splineutil2.c
    sed -r -i 's#\bb.st_mtime#getenv("SOURCE_DATE_EPOCH") ? atol(getenv("SOURCE_DATE_EPOCH")) : &#g'  fontforge/parsepfa.c fontforge/sfd.c fontforge/svg.c
    sed -r -i 's#^\s*ttf_fftm_dump#if (!getenv("SOURCE_DATE_EPOCH")) ttf_fftm_dump#g'                 fontforge/tottf.c
    sed -r -i 's#sprintf\(.+ author \);#if (!getenv("SOURCE_DATE_EPOCH")) &#g'                        fontforgeexe/fontinfo.c
  ''
  + ''
    # Not sure this won't be a problem,
    # but for now don't try setting rpath as it fails
    # complaining the path is too long :(
    substituteInPlace CMakeLists.txt --replace "set_default_rpath()" ""
  ''
  ;

  # do not use x87's 80-bit arithmetic, rouding errors result in very different font binaries
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isi686 [ "-msse2" "-mfpmath=sse" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    readline uthash woff2 zeromq
    python3 freetype zlib glib libungif libpng libjpeg libtiff libxml2
  ]
    ++ lib.optionals withSpiro [libspiro]
    ++ lib.optionals withGTK [ gtk3 cairo pango ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ];

  #configureFlags = [ "--enable-woff2" ]
  #  ++ lib.optionals (!withPython) [ "--disable-python-scripting" "--disable-python-extension" ]
  #  ++ lib.optional withGTK "--enable-gtk2-use"
  #  ++ lib.optional (!withGTK) "--without-x"
  #  ++ lib.optional withExtras "--enable-fontforge-extras"
  #  ++ [
  #    # > You may provide option ˋ--without-libuninameslistˋ to build without this recommended feature
  #    "--without-libuninameslist"
  #  ];

  cmakeFlags = [
    "-DENABLE_LIBUNINAMESLIST=OFF"

    # Experimental
    "-DENABLE_TILE_PATH=ON"
    "-DENABLE_WRITE_PFM=ON"
  ];

  doCheck = false; # tries to wget some fonts
  doInstallCheck = doCheck;

  postInstall =
    # get rid of the runtime dependency on python
    lib.optionalString (!withPython) ''
      rm -r "$out/share/fontforge/python"
    '';

  enableParallelBuilding = true;

  meta = {
    description = "A font editor";
    homepage = http://fontforge.github.io;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.bsd3;
  };
}
