{ config, stdenv, fetchurl, fetchpatch, pkgconfig, libiconv
, libintl, expat, zlib, libpng, pixman, fontconfig, freetype
, x11Support? !stdenv.isDarwin, libXext, libXrender
, gobjectSupport ? true, glib
, xcbSupport ? x11Support, libxcb, xcbutil # no longer experimental since 1.12
, libGLSupported ? stdenv.lib.elem stdenv.hostPlatform.system stdenv.lib.platforms.mesaPlatforms
, glSupport ? config.cairo.gl or (libGLSupported && stdenv.isLinux && !stdenv.isAarch32 && !stdenv.isMips)
, libGL ? null # libGLU_combined is no longer a big dependency
, pdfSupport ? true
, darwin
}:

assert glSupport -> libGL != null;

let
  version = "1.17.2";
  inherit (stdenv.lib) optional optionals;
in stdenv.mkDerivation rec {
  name = "cairo-${version}";

  src = fetchurl {
    url = "https://cairographics.org/${if stdenv.lib.mod (builtins.fromJSON (stdenv.lib.versions.minor version)) 2 == 0 then "releases" else "snapshots"}/${name}.tar.xz";
    sha256 = "1pq1i10fkcijbcjzg8589bd6wx5s555nyrhw20ms4irabrjx8w3b";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/cairo/cairo/commit/2a21ed0293055540985e74375ff462502adc9754.patch";
      sha256 = "1c1a70gj88wz63v5vnb8aw73hisqaz9x8m0xidsqn0ncm2d35x8c";
    })
    # Fix crashes
    (fetchpatch {
      url = https://gitlab.freedesktop.org/cairo/cairo/commit/2d1a137f3d27b60538c58b25e867288c7b0b61bc.patch;
      sha256 = "1c95s9y065rgpwqckkgmn06vvdkrh3q8rjcgr269f163cy4lhvnc";
    })

    # fix FT_PIXEL_MODE_BGRA:
    #(fetchpatch {
    #  url = https://gitlab.freedesktop.org/cairo/cairo/merge_requests/18.patch;
    #  sha256 = "0ghccls55474c7lrzi6bbw2pr2f3nmhdn2m277i4rwjf1jl5ls5y";
    #})
    # Local copy JIC the PR or patch changes
    ./18.patch
  ];

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev"; # very small

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libiconv
    libintl
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    CoreGraphics
    CoreText
    ApplicationServices
    Carbon
  ]);

  propagatedBuildInputs = [ fontconfig expat freetype pixman zlib libpng ]
    ++ optionals x11Support [ libXext libXrender ]
    ++ optionals xcbSupport [ libxcb xcbutil ]
    ++ optional gobjectSupport glib
    ++ optional glSupport libGL
    ; # TODO: maybe liblzo but what would it be for here?

  configureFlags = if stdenv.isDarwin then [
    "--disable-dependency-tracking"
    "--enable-quartz"
    "--enable-quartz-font"
    "--enable-quartz-image"
    "--enable-ft"
  ] else ([ "--enable-tee" ]
    ++ optional xcbSupport "--enable-xcb"
    ++ optional glSupport "--enable-gl"
    ++ optional pdfSupport "--enable-pdf"
  );

  preConfigure =
  # On FreeBSD, `-ldl' doesn't exist.
    stdenv.lib.optionalString stdenv.isFreeBSD
       '' for i in "util/"*"/Makefile.in" boilerplate/Makefile.in
          do
            cat "$i" | sed -es/-ldl//g > t
            mv t "$i"
          done
       ''
    +
    ''
    # Work around broken `Requires.private' that prevents Freetype
    # `-I' flags to be propagated.
    sed -i "src/cairo.pc.in" \
        -es'|^Cflags:\(.*\)$|Cflags: \1 -I${freetype.dev}/include/freetype2 -I${freetype.dev}/include|g'
    substituteInPlace configure --replace strings $STRINGS
    '';

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = stdenv.lib.optionalString stdenv.isDarwin glib.flattenInclude;

  meta = with stdenv.lib; {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = http://cairographics.org/;

    license = with licenses; [ lgpl2Plus mpl10 ];

    platforms = platforms.all;
  };
}
